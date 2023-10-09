require "rails_helper"

describe "ar to ar associations" do
  before do
    ActiveRecord::Base.connection.execute(
      <<-SQL
        CREATE TABLE artists(
          id SERIAL PRIMARY KEY
        );

        CREATE TABLE artworks(
          id SERIAL PRIMARY KEY,
          artist_id INT
        );
      SQL
    )

    class Artist < ApplicationRecord
      has_many :artworks
    end

    class Artwork < ApplicationRecord
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
