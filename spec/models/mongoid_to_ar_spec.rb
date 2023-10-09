require "rails_helper"

describe "mongoid to ar associations" do
  before do
    class Artist
      include Mongoid::Document

      def artworks
        Artwork.where(artist_id: id.to_s)
      end
    end

    ActiveRecord::Base.connection.execute(
      <<-SQL
        CREATE TABLE artworks(
          id SERIAL PRIMARY KEY,
          artist_id VARCHAR
        );
      SQL
    )

    class Artwork < ApplicationRecord
      attribute :artist_id, :mongoid_id
      alias_attribute :artist, :artist_id

      def artist=(artist)
        self.artist_id = artist.id.to_s
      end

      def artist
        Artist.find_by(id: artist_id)
      end
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
