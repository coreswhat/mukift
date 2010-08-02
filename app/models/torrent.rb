
class Torrent < ActiveRecord::Base

  has_many :peers
  has_many :snatches
  
  belongs_to :user
end

