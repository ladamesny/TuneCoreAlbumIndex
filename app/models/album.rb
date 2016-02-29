class Album < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title]
  pg_search_scope :search, :against => :title,
    using: { tsearch: {dictionary: "english", prefix: true } },
    associated_against: { artist: :name, songs: :title },
    ignoring: :accents

  belongs_to :artist
  has_many :songs, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title, case_insensitive: false

  # Class Methods
  def self.prepare_albums_cache
    Album.all.each do |album|
      unless Rails.cache.exist?([:album, album.id, :artwork ])
        data = ITunesSearchAPI.lookup(:id => album.albumId, :country => "US", :media => "music", entity: "album" )
        Rails.cache.write([:album, album.id, :artwork ], data['artworkUrl100'])
      end
    end
  end

  def self.data_cached?
    id = self.last.id
    Rails.cache.exist?([:album, id, :artwork])
  end

  # Instance Method
  def artwork
    Rails.cache.fetch([:album, self.id, :artwork ])
  end

end
