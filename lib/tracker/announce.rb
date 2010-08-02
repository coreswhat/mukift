
module Tracker
  
  module Announce
    include Tracker::Support
  
    def announce(params, request_ip, config, messages, logger = nil)
      begin    
        resp = AnnounceResponse.new 
  
        set_logger logger
                        
        debug ":-) tracker.announce: event = [#{params[:event]}]"
        
        req = prepare_announce_req params, request_ip, config
  
        process_announce_req req, config
  
        prepare_announce_resp req, resp, config          
      rescue Failure => e
        resp.failure_reason = messages[e.message]
      rescue => e
        log_error e, (req.user if req)
        resp.failure_reason = messages[:server_error]
      end
      resp.out(logger)
    end

    def prepare_announce_req(params, request_ip, config)
      begin
        req = AnnounceRequest.new params
      rescue => e
        failure :invalid_request
      end
      req.ip = request_ip
      req.set_numwant config[:announce_resp_max_peers]      

      failure :invalid_request unless req.valid?
      
      set_torrent req
      set_user req
      set_client req, config
      
      req
    end

    def process_announce_req(req, config)
      req.current_action_at = Time.now

      peer = Peer.find_peer req.torrent, req.user, req.ip, req.port
      
      unless peer
        Peer.kreate! req.attributes, peer_connectable?(req.ip, req.port) unless req.stopped?
      else
        req.last_action_at = peer.last_action_at
        req.set_offsets peer.uploaded, peer.downloaded          
        increment_user_counters req, config[:bonus_rules]
        unless req.stopped?          
          Snatch.kreate! req.torrent, req.user if req.completed?
          peer.refresh_announce! req.attributes
        else
          peer.destroy
        end          
      end
      AnnounceLog.kreate! req.attributes if config[:log_announces]
    end

    def prepare_announce_resp(req, resp, config)
      resp.interval     = config[:announce_interval_seconds]
      resp.min_interval = config[:announce_min_interval_seconds]
      resp.complete     = req.torrent.seeders_count
      resp.incomplete   = req.torrent.leechers_count
      unless req.stopped?
        resp.compact    = req.compact
        resp.no_peer_id = req.no_peer_id
        resp.peers      = Peer.find_for_announce_resp req.torrent, req.user, req.numwant
      end
    end

    def increment_user_counters(req, bonus_rules)
      up_offset = req.up_offset
      
      if (req.seeder? && !req.completed?) && bonus_rules[:seeding]
        up_offset += (req.up_offset * bonus_rules[:seeding]).to_i # bonus for seeding
      end
      
      down_offset = req.torrent.free? ? 0 : req.down_offset
      
      req.user.increment_counters! up_offset, down_offset
    end
  end
end


  