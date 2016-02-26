class AlbumsController < ApplicationController

  def search;end

  def itunes
    response = ITunesSearchAPI.search(:term => params[:term], :country => "US", :media => "music")
    binding.pry
    redirect_to root_path
  end
end
