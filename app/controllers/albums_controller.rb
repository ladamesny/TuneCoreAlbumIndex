class AlbumsController < ApplicationController

  def index
    @all_albums = prepare_albums_index(Album.all)
    unless params[:page]
      session[:selections] = @all_albums.map{ |a| a['id'] }
    end
    @albums =  Kaminari.paginate_array(@all_albums).page(params[:page]).per(12)
  end

  def search;end

  def itunes
    @albums = search_for_albums params[:term]
    redirect_to root_path
  end
end
