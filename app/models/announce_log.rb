
class AnnounceLog < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :torrent
  
  def self.kreate!(attributes)
    l = new
    l.set_attributes attributes
    l.save!
    logger.debug ':-) announce log created' if logger
    l
  end

  def set_attributes(h)
    self.torrent            = h[:torrent]
    self.free_torrent       = h[:torrent].free?
    self.user               = h[:user]
    self.event              = h[:event]
    self.seeder             = h[:seeder]
    self.ip                 = h[:ip]
    self.port               = h[:port]
    self.up_offset          = h[:up_offset]
    self.down_offset        = h[:down_offset]
    self.time_interval      = h[:time_interval]
    self.client_code        = h[:client].code
    self.client_description = h[:client].description
    self.client_version     = h[:client].version
  end
end
