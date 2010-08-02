
class Peer < ActiveRecord::Base

  # finders concern
    
  def self.find_peer(t, u, ip, port)
    find :first, :conditions => {:torrent_id => t, :user_id => u, :ip => ip, :port => port}
  end

  def self.find_for_announce_resp(torrent, announcer, numwant)
    cols = ['id', 'torrent_id', 'user_id', 'port', 'started_at', 'last_action_at']
    find :all,
         :conditions => ['torrent_id = ? AND user_id != ?', torrent.id, announcer.id],
         :order => cols.random_element, # simple way to randomize retrieved peers
         :limit => numwant
  end 
end