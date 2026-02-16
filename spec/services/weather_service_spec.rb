require 'rails_helper'

RSpec.describe WeatherService do
  let(:address) { "Taubaté, SP" }
  let(:service) { WeatherService.new(address) }

  let(:location_data) do
    {
      lat: -23.02,
      lon: -45.55,
      zip: "12010-110",
      name: "Taubaté, SP, Brazil"
    }
  end

  let(:weather_api_data) do
    Hashie::Mash.new({
      main: { temp: 25, temp_max: 28, temp_min: 20 }
    })
  end

  before do
    allow_any_instance_of(LocationService).to receive(:fetch).and_return(location_data)
    Rails.cache.clear
  end

  describe "#fetch" do
    context "when it's the first time searching (cold cache)" do
      it "fetches from the API and marks cached as false" do
        client_double = instance_double(OpenWeather::Client)
        allow(OpenWeather::Client).to receive(:new).and_return(client_double)
        allow(client_double).to receive(:current_weather).and_return(weather_api_data)

        result = service.fetch

        expect(result[:temp]).to eq(25)
        expect(result[:cached]).to be false
      end
    end

    context "when data is already in cache (hot cache)" do
      it "returns cached data and marks cached as true" do
        client_double = instance_double(OpenWeather::Client)
        allow(OpenWeather::Client).to receive(:new).and_return(client_double)
        allow(client_double).to receive(:current_weather).and_return(weather_api_data)

        service.fetch

        expect(client_double).not_to receive(:current_weather)

        result = service.fetch
        expect(result[:cached]).to be true
        expect(result[:temp]).to eq(25)
      end
    end
  end
end
