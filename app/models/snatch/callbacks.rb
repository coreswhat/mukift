
class Snatch < ActiveRecord::Base

  # callbacks concern

  after_create :after_create_routine

  private
  
    def after_create_routine
      t = self.torrent.lock!
      t.increment :snatches_count
      t.increment :seeders_count
      t.decrement :leechers_count
      t.save!
    end
end