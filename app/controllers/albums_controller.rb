class AlbumsController < ApplicationController

  def index
    @albums = prepare_albums_index(Album.all)

  end

  def search;end

  def itunes
    @albums = search_for_albums params[:term]
    redirect_to root_path
  end
end
