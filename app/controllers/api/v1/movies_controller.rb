class Api::V1::MoviesController < ApplicationController
  
  def top_rated
    movies = Movie.top_rated
    render json: MovieSerializer.new(movies), status: :ok
  end
end