class Song < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title]
  pg_search_scope :search_by_title, :against => :title

  belongs_to :album

  validates_presence_of :title

  # Class Methods
  def self.prepare_songs_cache
    CacheSongsWorker.perform_async
  end

  def self.data_cached?
    id = self.last.id
    Rails.cache.exist?([:song, id, :artwork])
  end

  # Instance Method
  def preview
    Rails.cache.fetch([:song, self.id, :preview ])
  end

  def artist_name
    self.album.artist.name
  end

  def track_number
    Rails.cache.fetch([:song, self.id, :track_number ])
  end

  def track_time
    Rails.cache.fetch([:song, self.id, :track_time ])
  end
end
