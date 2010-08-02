
class PeerConn < ActiveRecord::Base
  
  has_many :peers

  after_create :debug_created
  
  private

    def debug_created
      logger.debug ':-) peer conn created' if logger
    end
end
