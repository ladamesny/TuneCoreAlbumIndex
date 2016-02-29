class Album < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => :title,
    using: { tsearch: {dictionary: "english" } },
    associated_against: { artist: :name, songs: :title },
    ignoring: :accents

  belongs_to :artist
  has_many :songs, dependent: :destroy

  validates_presence_of :title
  validates_uniqueness_of :title, case_insensitive: false

  # Class Methods
  def self.prepare_albums_cache
    Album.all.each do |album|
      unless Rails.cache.exist?([:album, album.id, :artwork ]).nil?
        data = ITunesSearchAPI.lookup(:id => album.albumId, :country => "US", :media => "music", entity: "album" )
        data['id'] = album.id
        Rails.cache.write([:album, album.id, :artwork ], data['artworkUrl100'])
      end
    end
  end

  # Instance Method
  def artwork
    Rails.cache.fetch([:album, self.id, :artwork ])
  end

end
