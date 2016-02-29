class CacheAlbumsWorker
  include Sidekiq::Worker

  def perform
    Album.all.each do |album|
      unless Rails.cache.exist?([:album, album.id, :artwork ]).nil?
        data = ITunesSearchAPI.lookup(:id => album.albumId, :country => "US", :media => "music", entity: "album" )
        data['id'] = album.id
        Rails.cache.write([:album, album.id, :artwork ], data['artworkUrl100'])
      end
    end
  end
end
