class ApixuApi
  def self.weather_in(city)
    city = city.downcase

    Rails.cache.fetch("WEATHER_#{city}", expires_in: 15.minutes.from_now) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}"

    response = HTTParty.get "#{url}&q=#{ERB::Util.url_encode(city)}"
    weather = response.parsed_response["current"]

    return nil if weather.nil?

    Weather.new(weather)
  end

  def self.key
    ENV['APIXU_APIKEY']
  end
end
