
class Snatch < ActiveRecord::Base
  
  belongs_to :torrent
  belongs_to :user
  
  def self.kreate!(torrent, user) 
    unless find_by_torrent_id_and_user_id(torrent, user)
      create! :torrent => torrent, :user => user
    end 
  end
end
