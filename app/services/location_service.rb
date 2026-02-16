class LocationService
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def fetch
    location = Geocoder.search(address).first

    if location
      {
        name: location.address,
        lat: location.latitude,
        lon: location.longitude,
        zip: location.postal_code
      }
    else
      Rails.logger.info "[LocationService] No location found for address: #{address}"
      nil
    end
  rescue => e
    Rails.logger("[LocationService] Failed to fetch location. #{e.message}")
    nil
  end
end
