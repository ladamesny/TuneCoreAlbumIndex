class SongsController < ApplicationController

  def index
    Song.prepare_songs_cache unless Song.data_cached?
    all_songs = Song.all
    @songs =  Kaminari.paginate_array(all_songs).page(params[:page]).per(25)
  end
end
