import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :taiwan_buoys, TaiwanBuoysWeb.Endpoint,
  url: [host: "taiwanbuoys.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Quantum jobs
config :taiwan_buoys, TaiwanBuoys.Scheduler,
  jobs: [
    # every 30 minutes update buoys
    {"*/30 * * * *",
     {TaiwanBuoys.Scraper, :get_all_buoy_data, [&TaiwanBuoys.BuoyDataServer.put_data_location/2]}},
    # every 6 hours update forecast
    {"*/30 * * * *",
     {TaiwanBuoys.ForecastScraper.Forecast, :get_all_forecast_data,
      [&TaiwanBuoys.ForecastScraper.ForecastDataServer.put_data_location/2]}},
    # every day midnight update tides and weather forecast
    {"0 0 * * *",
     {TaiwanBuoys.Tide, :get_all_tide_data, [&TaiwanBuoys.TideDataServer.put_data_location/2]}}
    # {"0 0 * * *",
    #  {TaiwanBuoys.Weather, :get_all_weather_data,
    #   [&TaiwanBuoys.WeatherDataServer.put_data_location/2]}}
  ]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :taiwan_buoys, TaiwanBuoysWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :taiwan_buoys, TaiwanBuoysWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
config :taiwan_buoys, :local, false
