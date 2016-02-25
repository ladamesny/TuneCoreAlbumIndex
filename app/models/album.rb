class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs

  validates_presence_of :title
end
