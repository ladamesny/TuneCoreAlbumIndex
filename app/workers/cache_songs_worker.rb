class CacheSongsWorker
  include Sidekiq::Worker

  def perform
    Song.all.each do |song|
      unless Rails.cache.exist?([:song, song.id, :track_number ]).nil?
        data = ITunesSearchAPI.lookup(:id => song.songId, :country => "US", :media => "music", entity: "song" )
        data['id'] = song.id
        Rails.cache.write([:song, song.id, :track_number ], data['trackNumber'])
        Rails.cache.write([:song, song.id, :track_time ], data['trackTimeMillis'])
        Rails.cache.write([:song, song.id, :preview ], data['previewUrl'])
      end
    end
  end
end
