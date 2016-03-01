require 'rails_helper'

describe Song do
  it "has a valid factory" do
    expect(build(:song)).to be_valid
  end

  it { should validate_presence_of(:title) }

  it "returns the artists name" do
    radiohead = create(:artist, name: "Radiohead")
    in_rainbows = create(:album, title: "In Rainbows")
    house_of_cards = create(:song, title: 'House of Cards', album: in_rainbows, artist: radiohead )
    expect(house_of_cards.artist_name).to eq("Radiohead")
  end

  describe "Methods" do
    before :each do

      # Artists
      kanye_west = create(:artist, name: "Kanye West")
      led_zeppelin = create(:artist, name: "Led Zeppelin")
      john_coltrane = create(:artist, name: "John Coltrane")
      bob_marley = create(:artist, name: "Bob Marley")
      love_artist = create(:artist, name: "Love")
      # Albums
      heartbreaks = create(:album, title: "808 & Heartbreaks")
      led_zeppelin_II_remastered = create(:album, title: "Led Zeppelin II")
      love_supreme = create(:album, title: 'A Love Supreme')
      chant_down_babylon = create(:album, title: "Chant Down Babylon")
      sample_album = create(:album, title: "Sample Album")
      # Songs - songs are ordered by track number. track number is collected from api
      @heartless = create(:song, title: 'Heartless', album: heartbreaks, artist: kanye_west )
      @love_lock_down = create(:song, title: 'Love Lockdown', album: heartbreaks, artist: kanye_west )
      @whole_lotta_love = create(:song, title: 'A Whole Lotta Love', album: led_zeppelin_II_remastered, artist: led_zeppelin)
      @dedicated_to_you = create(:song, title: 'Dedicated to You', album: love_supreme, artist: john_coltrane)
      @johnny_was = create(:song, title: 'Johnny Was', album: chant_down_babylon, artist: bob_marley)
      @loves_song = create(:song, title: 'Sample Song', album: sample_album, artist: love_artist)
    end

    it "returns songs grouped by album and sorted by track number" do
      songs = Song.sorted_songs
      expected_results = [@heartless, @love_lock_down, @whole_lotta_love, @dedicated_to_you, @johnny_was, @loves_song]
      expect(songs).to match_array(expected_results)
    end

    it "returns the artist's name" do
      expect(@johnny_was.artist_name).to eq('Bob Marley')
    end
  end

  describe "Search returns matches in" do
    before :each do

      # Artists
      kanye_west = create(:artist, name: "Kanye West")
      led_zeppelin = create(:artist, name: "Led Zeppelin")
      john_coltrane = create(:artist, name: "John Coltrane")
      bob_marley = create(:artist, name: "Bob Marley")
      love_artist = create(:artist, name: "Love")
      # Albums
      heartbreaks = create(:album, title: "808 & Heartbreaks")
      led_zeppelin_II_remastered = create(:album, title: "Led Zeppelin II")
      love_supreme = create(:album, title: 'A Love Supreme')
      chant_down_babylon = create(:album, title: "Chant Down Babylon")
      sample_album = create(:album, title: "Sample Album")
      # Songs - songs are ordered by track number. track number is collected from api
      @heartless = create(:song, title: 'Heartless', album: heartbreaks, artist: kanye_west )
      @love_lock_down = create(:song, title: 'Love Lockdown', album: heartbreaks, artist: kanye_west )
      @whole_lotta_love = create(:song, title: 'A Whole Lotta Love', album: led_zeppelin_II_remastered, artist: led_zeppelin)
      @dedicated_to_you = create(:song, title: 'Dedicated to You', album: love_supreme, artist: john_coltrane)
      @johnny_was = create(:song, title: 'Johnny Was', album: chant_down_babylon, artist: bob_marley)
      @loves_song = create(:song, title: 'Sample Song', album: sample_album, artist: love_artist)
    end

    context "lower case terms" do
      it "matches song titles" do
        songs = Song.return_matched_songs "love"
        expect(songs).to include(@love_lock_down, @whole_lotta_love)
      end
      it "matches album titles" do
        songs = Song.return_matched_songs "love"
        expect(songs).to include(@dedicated_to_you)
      end
      it "matches artist name" do
        songs = Song.return_matched_songs "bob marley"
        expect(songs).to include(@johnny_was)
      end
      it "matches artist, song and album names" do
        songs = Song.return_matched_songs "love"
        expect(songs).to include(@love_lock_down, @dedicated_to_you, @loves_song)
      end
    end

    context "upper case terms" do
      it "matches song titles" do
        songs = Song.return_matched_songs "LOVE"
        expect(songs).to include(@love_lock_down, @whole_lotta_love)
      end
      it "matches album titles" do
        songs = Song.return_matched_songs "LOVE"
        expect(songs).to include(@dedicated_to_you)
      end
      it "matches artist name" do
        songs = Song.return_matched_songs "BOB MARLEY"
        expect(songs).to include(@johnny_was)
      end
      it "matches artist, song and album names" do
        songs = Song.return_matched_songs "LOVE"
        expect(songs).to include(@love_lock_down, @dedicated_to_you, @loves_song)
      end
    end

    context "partial terms" do
      it "matches song titles" do
        songs = Song.return_matched_songs "lo"
        expect(songs).to include(@love_lock_down, @whole_lotta_love)
      end
      it "matches album titles" do
        songs = Song.return_matched_songs "lo"
        expect(songs).to include(@dedicated_to_you)
      end
      it "matches artist name" do
        songs = Song.return_matched_songs "marl"
        expect(songs).to include(@johnny_was)
      end
      it "matches artist, song and album names" do
        songs = Song.return_matched_songs "lo"
        expect(songs).to include(@love_lock_down, @dedicated_to_you, @loves_song)
      end
    end


    context "no term" do
      it "returns all records" do
        songs = Song.return_matched_songs ""
        expected_results = [@heartless, @love_lock_down, @whole_lotta_love, @dedicated_to_you, @johnny_was, @loves_song]
        expect(songs).to match_array(expected_results)
      end
    end

  end
end
