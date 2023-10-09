require "rails_helper"

describe "mongoid to mongoid associations" do
  before do
    class Artist
      include Mongoid::Document
      has_many :artworks
    end

    class Artwork
      include Mongoid::Document
      belongs_to :artist
    end
  end

  it "does a lot for us" do
    artist = Artist.create
    artwork = Artwork.create(artist: artist)

    expect(artist.artworks).to eq [artwork]
    expect(artwork.artist).to eq artist
    expect(Artwork.where(artist: artist)).to eq [artwork]

    another_artist = Artist.create
    artwork.update(artist: another_artist)
    artist.reload

    expect(artist.artworks).to eq []
    expect(artwork.artist).to eq another_artist
    expect(Artwork.where(artist: artist)).to eq []
    expect(Artwork.where(artist: another_artist)).to eq [artwork]
  end
end
