class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def search_for_albums term
    albums = Album.search(term)
  end

  private

  def associated_album  record
    case record.class.to_s
    when "Artist"
      record.albums
    when "Song"
      record.album
    when "Album"
      record
    end
  end
end
