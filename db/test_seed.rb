artists = ['Kanye West', 'Bob Marley',  'Led Zeppelin']

artists.each do |name|

  response = ITunesSearchAPI.search(:term => name, :country => "US", :media => "music")

  artist_specific_results = response.select{ |record| record['artistName'] == name  }

  # First create the artist object
  artist = Artist.create(name: name, artistId: artist_specific_results.first[:artistId] )

  # Get Unique Album Names for current artist
  albums = artist_specific_results.map{ |record| { :title => record['collectionName'], :albumId => record['collectionId'] } }.uniq!{ |hash| hash[:title] }

  albums.each do |album|
    if album[:title].present?
      newAlbum = Album.create(artist_id: artist.id,title: album[:title], albumId: album[:albumId])
      album_specific_results = artist_specific_results.select{ |record| record['collectionName'] == newAlbum.title }
      album_specific_results.each do |track|
        unless newAlbum.songs.map{|song| song.title }.include?(track['trackName'])
          song = Song.create(title: track['trackName'], songId: track['trackId'])
          newAlbum.songs << song
          artist.songs << song
        end
      end
      newAlbum.save!
    end
  end

  artist.save!
end

