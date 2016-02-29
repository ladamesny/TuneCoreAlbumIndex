class Song < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title]
  pg_search_scope :search, :against => :title,
    using: { tsearch: { dictionary: "english", prefix: true } },
    associated_against: { artist: :name, album: :title },
    ignoring: :accents

  belongs_to :album
  belongs_to :artist

  validates_presence_of :title

  # Class Methods
  def self.prepare_songs_cache
    Song.all.each do |song|
      unless Rails.cache.exist?([:song, song.id, :track_number ])
        data = ITunesSearchAPI.lookup(:id => song.songId, :country => "US", :media => "music", entity: "song" )
        Rails.cache.write([:song, song.id, :track_number ], data['trackNumber'])
        Rails.cache.write([:song, song.id, :track_time ], data['trackTimeMillis'])
        Rails.cache.write([:song, song.id, :preview ], data['previewUrl'])
      end
    end
  end

  def self.data_cached?
    id = Song.last.id
    Rails.cache.exist?([:song, id, :track_number])
  end

  def self.sorted_songs
    method = (Song.data_cached? ? :track_number : :id)
    Album.all.map{ |album| album.songs.sort_by(&method) }.flatten!
  end

  def self.return_matched_songs term
    (term.present? ? Song.search(term).sort_by(&:track_number) : Song.sorted_songs)
  end

  # Instance Method

  def artist_name
    self.album.artist.name
  end

  def preview
    Rails.cache.fetch([:song, self.id, :preview ])
  end

  def track_number
    Rails.cache.fetch([:song, self.id, :track_number ])
  end

  def track_time
    Rails.cache.fetch([:song, self.id, :track_time ])
  end
end
