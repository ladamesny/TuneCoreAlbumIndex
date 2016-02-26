artists = ['Kanye West', 'Radiohead', 'The Killers', 'Nas', 'Homeboy Sandman', 'The Strokes', 'Daft Punk', 'Bob Marley', 'Alicia Keys', 'Aphex Twin', 'John Coltrane', 'Coldplay', 'Drake']

artists.each do |name|

  puts "@@@@@@@@@@@---Creating Artist: #{name}---@@@@@@@@@@@@@@@@"
  puts


  response = ITunesSearchAPI.search(:term => name, :country => "US", :media => "music")

  artist_specific_results = response.select{ |record| record['artistName'] == name  }

  # First create the artist object
  artist = Artist.create(name: name, artistId: artist_specific_results.first[:artistId] )

  # Get Unique Album Names for current artist
  albums = artist_specific_results.map{ |record| { :title => record['collectionName'], :albumId => record['collectionId'] } }.uniq!{ |hash| hash[:title] }

  albums.each do |album|
    if album[:title].present?
      puts "Creating Album: #{album[:title]}"
      newAlbum = Album.create(title: album[:title], albumId: album[:albumId])
      album_specific_results = artist_specific_results.select{ |record| record['collectionName'] == newAlbum.title }
      album_specific_results.each do |track|
        puts " := #{track['trackName']}"
        unless newAlbum.songs.map{|song| song.title }.include?(track['trackName'])
          song = Song.create(title: track['trackName'], songId: track['trackId'])
          newAlbum.songs << song
        end
      end
      newAlbum.save!
      puts
      puts "----------------"
      puts
    end
  end

  artist.save!
end

artist_count = Artist.count
albums_count = Album.count
song_count = Song.count

puts '###################---Database Totals---########################'
puts "Artists: #{artist_count}       Albums: #{albums_count}         Songs: #{song_count}"
