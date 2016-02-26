class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title

  def self.create_album term
    response = ITunesSearchAPI.search(:term => term, :country => "US", :media => "music", kind: 'Album')
    self.create(title: response.first['collectionName'], itunes_id: response.first['collectionId'])
  end
end
