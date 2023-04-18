defmodule TaiwanBuoys.ForecastScraper.ForecastData do
  defstruct [
    :date_time,
    :wind_speed,
    :wind_direction,
    :wave_height,
    :wave_direction,
    :wave_period
  ]
end
