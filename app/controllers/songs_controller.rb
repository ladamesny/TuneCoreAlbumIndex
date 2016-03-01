class SongsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    all_songs = Song.sorted_songs
    @songs =  Kaminari.paginate_array(all_songs).page(params[:page]).per(10)
  end

  def search
    redirect_to songs_path unless params[:search].present?
    @term = params[:search]
    @songs = Song.return_matched_songs(params[:search])
  end

  def run_caching
    CacheSongsWorker.perform_async
  end
end
