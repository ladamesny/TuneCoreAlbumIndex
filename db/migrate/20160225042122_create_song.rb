class CreateSong < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :album_id
      t.text :title
      t.text :itunes_id
      t.timestamps
    end
  end
end
