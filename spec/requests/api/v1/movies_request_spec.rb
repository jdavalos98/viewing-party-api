require 'rails_helper'

RSpec.describe Api::V1::MoviesController, type: :controller do
  describe "GET #top_rated" do
    it "returns a successful response with top-rated movies" do
      movies = [
        Movie.new(id: 1, title: "Movie 1", vote_average: 8.5),
        Movie.new(id: 2, title: "Movie 2", vote_average: 7.9)
      ]
      allow(Movie).to receive(:top_rated).and_return(movies)

      get :top_rated

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/vnd.api+json")

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data].size).to eq(2)
      expect(json_response[:data].first[:attributes][:title]).to eq("Movie 1")
      expect(json_response[:data].first[:attributes][:vote_average]).to eq(8.5)
    end

    it "returns a 500 status when the API request fails" do
      allow(Movie).to receive(:top_rated).and_raise(StandardError.new("Failed to fetch top-rated movies"))
    
      get :top_rated
    
      expect(response).to have_http_status(500)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors].first[:detail]).to eq("Failed to fetch top-rated movies")
    end

    it "returns a 500 status for invalid JSON response" do
      allow(Movie).to receive(:top_rated).and_raise(JSON::ParserError)
    
      get :top_rated
    
      expect(response).to have_http_status(500)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors].first[:detail]).to eq("Invalid response from Movie DB API")
    end
  end
end