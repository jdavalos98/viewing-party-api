class Movie
  attr_reader :id, :title, :vote_average

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @vote_average = data[:vote_average]
  end

  def self.top_rated
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated") do |req|
      req.params['api_key'] = ENV['MOVIE_DB_API_KEY']
    end

    if response.success?
      begin
        data = JSON.parse(response.body, symbolize_names: true)[:results].first(20)
        data.map { |movie_data| Movie.new(movie_data) }
      rescue JSON::ParserError
        []
      end
    else
      []
    end
  rescue Faraday::ConnectionFailed
    raise StandardError.new("Network failure: Unable to reach The Movie DB API")
  end
end