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

  describe "Search" do
    before :each do

      # Artists
      kanye_west = create(:artist, name: "Kanye West")
      led_zeppelin = create(:artist, name: "Led Zeppelin")
      john_coltrane = create(:artist, name: "John Coltrane")
      bob_marley = create(:artist, name: "Bob Marley")

      # Albums
      heartbreaks = create(:album, title: "808 & Heartbreaks")
      led_zeppelin_II_remastered = create(:album, title: "Led Zeppelin II")
      love_supreme = create(:album, title: 'A Love Supreme')
      chant_down_babylon = create(:album, title: "Chant Down Babylon")

      # Songs - songs are ordered by track number. track number is collected from api
      @heartless = create(:song, title: 'Heartless', album: heartbreaks, artist: kanye_west )
      @love_lock_down = create(:song, title: 'Love Lockdown', album: heartbreaks, artist: kanye_west )
      @whole_lotta_love = create(:song, title: 'A Whole Lotta Love', album: led_zeppelin_II_remastered, artist: led_zeppelin)
      @dedicated_to_you = create(:song, title: 'Dedicated to You', album: love_supreme, artist: john_coltrane)
      @johnny_was = create(:song, title: 'Johnny Was', album: chant_down_babylon, artist: bob_marley)
    end

    it "returns songs grouped by album and sorted by track number" do
      songs = Song.sorted_songs
      expected_results = [@heartless, @love_lock_down, @whole_lotta_love, @dedicated_to_you, @johnny_was]
      expect(songs).to match_array(expected_results)
    end

    it "returns a list of matches"

    it "returns the artist's name"
  end
end
