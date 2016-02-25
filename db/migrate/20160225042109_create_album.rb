class CreateAlbum < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :artist_id
      t.text :title
      t.text :itunes_id
      t.timestamps
    end
  end
end
