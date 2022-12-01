# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :taiwan_buoys, TaiwanBuoysWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 5454],
  secret_key_base: "daCvMQAMkdG5YMZvKHOqfZJDRg0KKT12SA5qgn7QOIvgIY21cRXSRshQdaHJSX72",
  render_errors: [view: TaiwanBuoysWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TaiwanBuoys.PubSub,
  live_view: [signing_salt: "sTrRiaFM"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js js/charts.js js/home_charts.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Timezones
config :elixir, :time_zone_database, Tz.TimeZoneDatabase


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
