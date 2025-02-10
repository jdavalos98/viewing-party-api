require 'rails_helper'

RSpec.describe "Movies API", type: :request do 
  describe "GET /api/vq/movies/top_rated" do
    it "returns a successful response" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_API_KEY']}")

      get "/api/v1/movies/top_rated"

      expect(response).to have_http_status(:success)
    end

    it "returns top rated movies with correct JSON structure" do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_API_KEY']}")
      
      get "/api/v1/movies/top_rated"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_an(Array)
      expect(json[:data].size).to be <= 20
      expect(json[:data].first[:attributes]).to have_key(:title)
      expect(json[:data].first[:attributes]).to have_key(:vote_average)
    end
  end
end