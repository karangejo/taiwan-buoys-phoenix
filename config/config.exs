# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :taiwan_buoys, TaiwanBuoysWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 5454],
  secret_key_base: "daCvMQAMkdG5YMZvKHOqfZJDRg0KKT12SA5qgn7QOIvgIY21cRXSRshQdaHJSX72",
  render_errors: [view: TaiwanBuoysWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TaiwanBuoys.PubSub,
  live_view: [signing_salt: "sTrRiaFM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Timezones
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Quantum jobs
config :taiwan_buoys, TaiwanBuoys.Scheduler,
  jobs: [
    # every 30 minutes update buoys
    {"*/30 * * * *",
      {TaiwanBuoys.Scraper, :get_all_buoy_data, [&TaiwanBuoys.BuoyDataServer.put_data_location/2]}
    },
    # every day midnight update tides and weather forecast
    {"0 0 * * *",
      {TaiwanBuoys.Tide, :get_all_tide_data, [&TaiwanBuoys.TideDataServer.put_data_location/2]}
    },
    {"0 0 * * *",
      {TaiwanBuoys.Weather, :get_all_weather_data, [&TaiwanBuoys.WeatherDataServer.put_data_location/2]}
    }
  ]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
