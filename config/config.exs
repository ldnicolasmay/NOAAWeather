use Mix.Config

config :noaa_weather, noaa_weather_url: "https://w1.weather.gov/xml/current_obs/display.php"
config :logger, level: :info
config :logger, :console, format: "$time $metadata[$level] $levelpad$message\n"

