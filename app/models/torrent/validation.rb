
class Torrent < ActiveRecord::Base

  # validation concern
  
  def validate
    validate_counters
  end
  
  private
         
    def validate_counters
      raise 'torrent seeders_count cannot be negative!' if self.seeders_count < 0
      raise 'torrent leechers_count cannot be negative!' if self.leechers_count < 0
    end
end