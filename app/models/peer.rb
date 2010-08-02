
class Peer < ActiveRecord::Base

  require 'ipaddr'
  
  belongs_to :user
  belongs_to :torrent
  belongs_to :peer_conn

  def self.kreate!(attributes, connectable)
    p = new
    p.set_attributes attributes
    p.set_connectivity(connectable)
    p.save!
    logger.debug ':-) peer created' if logger
    p
  end
 
  def refresh_announce!(attributes)
    set_attributes attributes
    save!
    logger.debug ':-) peer updated' if logger
  end

  def set_attributes(h)
    self.torrent            = h[:torrent]
    self.user               = h[:user]
    self.ip                 = h[:ip]
    self.port               = h[:port]
    self.uploaded           = h[:uploaded]
    self.downloaded         = h[:downloaded]
    self.leftt              = h[:left]
    self.seeder             = h[:seeder]
    self.peer_id            = h[:peer_id]
    self.last_action_at     = h[:current_action_at]
    self.client_code        = h[:client].code
    self.client_description = h[:client].description
    self.client_version     = h[:client].version
  end

  def set_connectivity(connectable)
    # note: orphaned peer_conns are supposed to be wiped by a background task
    if new_record?
      self.peer_conn = PeerConn.find_by_ip_and_port(self.ip, self.port) || PeerConn.new(:ip => self.ip, :port => self.port)
    end
    self.peer_conn.connectable = connectable
    self.peer_conn.save
  end

  def self.make_compact_ip(ip, port)
    ipaddr = IPAddr.new ip
    if ipaddr.ipv4?
      ipaddr.hton << [port.to_i].pack('n*')
    end
  end    
end


