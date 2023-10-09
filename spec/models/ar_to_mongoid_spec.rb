require "rails_helper"

describe "ar to mongoid associations" do
  before do
    ActiveRecord::Base.connection.execute(
      <<-SQL
        CREATE TABLE artists(
          id SERIAL PRIMARY KEY
        );
      SQL
    )

    class Artist < ApplicationRecord
      include HasMongoidAssociation
      # has_many_mongoid :artworks
    end

    class Artwork
      include Mongoid::Document

      field :artist_id, type: Integer

      def artist
        Artist.find_by(id: artist_id)
      end

      def artist=(artist)
        self.artist_id = artist.id
      end
    end

    Artist.has_many_mongoid :artworks
  end

  it "does a lot for us" do
    artist = Artist.create
    artwork = Artwork.create(artist: artist)

    expect(artist.artworks).to eq [artwork]
    expect(artwork.artist).to eq artist
    # expect(Artwork.where(artist: artist)).to eq [artwork]

    another_artist = Artist.create
    artwork.update(artist: another_artist)
    artist.reload

    expect(artist.artworks).to eq []
    expect(artwork.artist).to eq another_artist
    # expect(Artwork.where(artist: artist)).to eq []
    # expect(Artwork.where(artist: another_artist)).to eq [artwork]
  end
end
