class WeatherService
  CACHE_DURATION = 30.minutes
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def fetch
    location = LocationService.new(address).fetch
    return nil unless location

    lat = location[:lat]
    lon = location[:lon]

    cache_key = location[:zip].present? ? "weather/zip-#{location[:zip]}" : "weather/coords-#{lat}-#{lon}".parameterize
    cached = !Rails.cache.read(cache_key).nil?

    response = Rails.cache.fetch(cache_key, expires_in: CACHE_DURATION) do
      data = fetch_from_api(lat, lon)
      data.merge(name: location[:name], zip: location[:zip]) if data
    end

    response.merge(cached: cached)
  end

  def fetch!
    weather = fetch
    raise "Unable to fetch weather data for address: #{address}" unless weather

    weather
  end

  def fetch_from_api(lat, lon)
    client = OpenWeather::Client.new(api_key: Rails.application.credentials.dig(:openweather_api_key))
    data = client.current_weather(lat: lat, lon: lon, units: "metric")

    {
      temp: data.main.temp.round,
      high: data.main.temp_max.round,
      low: data.main.temp_min.round
    }
  rescue OpenWeather::Errors::Fault => e
    Rails.logger.error "[WeatherService] Failed to Fetch Openweather: #{e.message}"
    nil
  end
end
