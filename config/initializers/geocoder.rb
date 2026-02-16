Geocoder.configure(
  lookup: :google,
  api_key: Rails.application.credentials.google_api_key,
  use_https: true
)
