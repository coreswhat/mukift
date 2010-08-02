
module Tracker
   
  module Support
    
    require 'socket'
    
    # failure
    
      class Failure < StandardError
      end
      
      def failure(error_key)
        raise Failure, error_key
      end 
  
    # logging
  
      def set_logger(logger)
        @@logger = logger
      end
      
      def debug(s)
        @@logger.debug s if @@logger
      end
    
      def log_error(e, user = nil)
        ErrorLog.kreate_with_error! e, user
      end

    # requests manipulation

      def set_torrent(req, info_hash = nil)
        req.torrent = Torrent.find_by_info_hash(info_hash || req.info_hash)
  
        if req.torrent && req.torrent.active?
          debug ":-) valid torrent: #{req.torrent.id} [#{req.torrent.name}]"
        else
          debug ":-o torrent not found or inactive for received info hash"
          failure :invalid_torrent          
        end
      end
  
      def set_user(req)
        u = User.find_by_passkey(req.passkey)
        if u && u.active?
          debug ":-) valid passkey, user found and active: #{u.id} [#{u.username}]"
          req.user = u
        else
          debug ":-o invalid passkey: #{req.passkey}"
          failure :invalid_passkey
        end        
      end
      
      def set_client(req, config)  
        begin
          req.client = parse_client req.peer_id, config[:ban_unknown_clients]
        rescue
          failure :invalid_request
        end
        if req.client.banned?
          failure :client_banned
        elsif req.client.banned_version?
          failure :client_version_banned
        end 
      end    

    # peer
      
      def peer_connectable?(ip, port)
        begin
          s = TCPSocket.open(ip, port)
        rescue 
          debug ":-o peer [#{ip}:#{port}] is not connectable"
          return false
        ensure
          s.close if s
        end
        debug ":-) peer [#{ip}:#{port}] is connectable"
        true
      end
      
    # client
      
      # Return a stored Client object or, if code not found in the database, an unsaved
      # instance of Client containing the code and version received.
      def parse_client(peer_id, ban_unknown = false)
        if peer_id.size == 20
          if peer_id[0, 1] == '-' && peer_id[7, 1] == '-'          
            code = peer_id[1, 2] # azureus style: '-UT1770-000000000000'
            version = peer_id[3, 4]
          else                                                     
            code = peer_id[0, 1] # shadow style: 'S12345---00000000000'
            version = peer_id[1, 5].gsub('-', '')
          end
          c = Client.find_by_code code
          unless c
            c = Client.new :code => code, :description => code
            c.banned = ban_unknown
          end
          c.version = Integer(version)
          c
        end      
      end
    end
end