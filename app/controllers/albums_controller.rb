class AlbumsController < ApplicationController

  def index
    Album.prepare_albums_cache unless Album.data_cached?
    all_albums = Album.all
    @albums =  Kaminari.paginate_array(all_albums).page(params[:page]).per(12)
  end

  def search;end

  def itunes
    @albums = search_for_albums params[:term]
    redirect_to root_path
  end
end
