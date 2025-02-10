class Movie < ApplicationRecord
  validates :title, presence: true
  validates :vote_average, presence: true, numericality: true

  def self.top_rated
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated") do |req|
      req.params['api_key'] = ENV['Movie_DB_API_KEY']
    end

    data = JSON.parse(response.body symbolize_names: true)[:results].first(20)

    data.map { |movie_data| Movie.new(movie_data) }
  end
end