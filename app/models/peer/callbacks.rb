
class Peer < ActiveRecord::Base

  # callbacks concern

  before_create :init_new_record

  after_create :after_create_routine

  after_destroy :after_destroy_routine

  private
  
    def init_new_record
      self.started_at = Time.now
      self.compact_ip = self.class.make_compact_ip self.ip, self.port
    end

    def after_create_routine
      t = self.torrent.lock!
      t.increment!(seeder? ? :seeders_count : :leechers_count)
    end

    def after_destroy_routine
      t = self.torrent.lock!
      t.decrement!(seeder? ? :seeders_count : :leechers_count)
    end
end