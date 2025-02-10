class Api::V1::MoviesController < ApplicationController
  def top_rated
    begin
      movies = Movie.top_rated
      render json: MovieSerializer.new(movies), status: :ok, content_type: "application/vnd.api+json"
    rescue Faraday::ConnectionFailed
      render json: { errors: [{ detail: "Service unavailable: Unable to reach The Movie DB API" }] }, status: :service_unavailable
    rescue JSON::ParserError
      render json: { errors: [{ detail: "Invalid response from Movie DB API" }] }, status: :internal_server_error
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :internal_server_error
    end
  end
end