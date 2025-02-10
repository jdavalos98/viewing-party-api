class Api::V1::MoviesController < ApplicationController
  
  def top_rated
    movies = Movie.top_rated

    if movies.nil?
      render json: ErrorSerializer.format_error({ message: "Failed to fetch top-rated movies", status: 500 }), status: :internal_server_error
    else
      render json: MovieSerializer.new(movies), status: :ok
    end
  end
end