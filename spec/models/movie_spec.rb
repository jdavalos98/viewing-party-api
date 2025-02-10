require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe ".top_rated" do
    it "returns an array of Movie objects when the API call is successful" do
      json_response = {
        results: [
          { id: 1, title: "Movie 1", vote_average: 8.5 },
          { id: 2, title: "Movie 2", vote_average: 7.9 }
        ]
      }.to_json

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: ENV['MOVIE_DB_API_KEY'] })
        .to_return(status: 200, body: json_response)

      movies = Movie.top_rated

      expect(movies).to be_an(Array)
      expect(movies.size).to eq(2)
      expect(movies.first).to be_a(Movie)
      expect(movies.first.title).to eq("Movie 1")
      expect(movies.first.vote_average).to eq(8.5)
    end

    it "returns an empty array when the API request fails" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: ENV['MOVIE_DB_API_KEY'] })
        .to_return(status: 500, body: "")

      movies = Movie.top_rated

      expect(movies).to eq([])
    end

    it "returns an empty array when the API response is invalid" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: ENV['MOVIE_DB_API_KEY'] })
        .to_return(status: 200, body: "invalid_json")

      movies = Movie.top_rated

      expect(movies).to eq([])
    end
  end
end