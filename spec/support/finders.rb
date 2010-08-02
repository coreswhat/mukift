
module Finders  

  # announce_log
  
    def find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder(t, u, ip, port, event, seeder)
      AnnounceLog.find_by_torrent_id_and_user_id_and_ip_and_port_and_event_and_seeder(t, u, ip, port, event, seeder) 
    end
  
  # snatch
  
    def find_snatch_by_torrent_and_user(t, u)
      Snatch.find_by_torrent_id_and_user_id(t, u)
    end  
    
  # peer
  
    def find_peer_by_torrent_and_user_and_ip_and_port(t, u, ip, port)
      Peer.find_by_torrent_id_and_user_id_and_ip_and_port t, u, ip, port
    end
    
  # peer_conn
  
    def find_peer_conn_by_ip_and_port(ip, port)
      PeerConn.find_by_ip_and_port(ip, port)
    end
end
