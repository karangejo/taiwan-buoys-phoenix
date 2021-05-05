defmodule TaiwanBuoysWeb.ChartView do
  use TaiwanBuoysWeb, :view

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
