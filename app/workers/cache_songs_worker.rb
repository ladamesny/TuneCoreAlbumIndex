class CacheSongsWorker
  include Sidekiq::Worker

  def perform
    begin
      Song.prepare_songs_cache unless Song.data_cached?
      Album.prepare_albums_cache unless Album.data_cached?
    rescue NoMethodError
      puts "****API Call to Itunes did not return results****"
    end
  end
end
