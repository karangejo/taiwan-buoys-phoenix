defmodule TaiwanBuoys.Scraper.BuoyData do
  defstruct [
    :date_time,
    :tidal_height,
    :wave_height,
    :wave_direction,
    :wave_period,
    :mean_wind_speed,
    :wind_direction,
    :maximum_wind,
    :water_temp_celcius,
    :air_temp_celcius,
    :pressure,
    :current_direction,
    :current_speed
  ]
end
