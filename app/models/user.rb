

class User < ActiveRecord::Base

  has_many :torrents
  has_many :peers
  has_many :snatches
  has_many :announce_logs
  has_many :error_logs

  def increment_counters!(up_offset, down_offset)
    raise 'offsets cannot be negative!' if up_offset < 0 || down_offset < 0

    if up_offset > 0 || down_offset > 0
      User.transaction do
        lock!
        self.uploaded += up_offset
        self.downloaded += down_offset
        set_ratio
        save!
      end
    end
  end

  def self.calculate_ratio(up, down)
    down != 0 ? sprintf("%.3f", (up / down.to_f)).to_f : 0
  end
  
  private

    def set_ratio
      self.ratio = User.calculate_ratio(self.uploaded, self.downloaded)
    end
end












