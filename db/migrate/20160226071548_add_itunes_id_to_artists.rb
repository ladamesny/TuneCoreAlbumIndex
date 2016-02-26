class AddItunesIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :artistId, :text
    add_column :albums, :albumId, :text
    add_column :songs, :songId, :text
    remove_column :albums, :itunes_id, :text
    remove_column :songs, :itunes_id, :text
  end
end
