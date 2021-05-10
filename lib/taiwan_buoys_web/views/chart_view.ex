defmodule TaiwanBuoysWeb.ChartView do
  use TaiwanBuoysWeb, :view

  alias TaiwanBuoys.Weather

  def pred_chart_labels(pred_data) do
    Enum.map(pred_data, fn %{"time" => value} ->
      value
    end)
  end

  def pred_wind_directions(pred_data) do
    Weather.get_noaa_values_by_attribute(pred_data,"windDirection")
    |> Enum.map(fn x ->
      Weather.degrees_to_direction(x)
    end)
  end

  def pred_wind_speed(pred_data) do
    Weather.get_noaa_values_by_attribute(pred_data,"windSpeed")
  end

  def pred_wave_directions(pred_data) do
    Weather.get_noaa_values_by_attribute(pred_data,"swellDirection")
    |> Enum.map(fn x ->
      Weather.degrees_to_direction(x)
    end)
  end

  def pred_wave_height(pred_data) do
    Weather.get_noaa_values_by_attribute(pred_data,"swellHeight")
  end

  def pred_wave_period(pred_data) do
    Weather.get_noaa_values_by_attribute(pred_data,"swellPeriod")
  end

  def tide_height(tide_data) do
    Enum.map(tide_data, fn x ->
      x.height
    end)
  end

  def tide_labels(tide_data) do
    Enum.map(tide_data, fn x ->
      x.time
    end)
  end

  def chart_labels(data) do
    Enum.map(data, fn x ->
      x.date_time
    end)
  end

  def wave_directions(data) do
    Enum.map(data, fn x ->
      x.wave_direction
    end)
  end

  def wave_height(data) do
    Enum.map(data, fn x ->
      x.wave_height
    end)
  end

  def wave_period(data) do
    Enum.map(data, fn x ->
      x.wave_period
    end)
  end

  def wind_directions(data) do
    Enum.map(data, fn x ->
      x.wind_direction
    end)
  end

  def wind_speed(data) do
    Enum.map(data, fn x ->
      case x.mean_wind_speed do
        "--" ->
          "--"
        speed ->
          Float.to_string(String.to_float(speed) * 1.94384)
      end
    end)
  end

  def max_wind_speed(data) do
    Enum.map(data, fn x ->
      x.maximum_wind
    end)
  end
end
