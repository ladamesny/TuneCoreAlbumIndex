class SongsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    all_songs = Song.sorted_songs
    @songs =  Kaminari.paginate_array(all_songs).page(params[:page]).per(10)
  end

  def search
    @songs = Song.return_matched_songs(params[:search])
  end

  def run_caching
    begin
      Song.prepare_songs_cache unless Song.data_cached?
      Album.prepare_albums_cache unless Album.data_cached?
    rescue NoMethodError
      puts "****API Call to Itunes did not return results****"
    end
  end
end
