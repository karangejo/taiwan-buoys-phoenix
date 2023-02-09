defmodule TaiwanBuoysWeb.HomeView do
  use TaiwanBuoysWeb, :view

  def display_date_time(datetime) do
    formated =
      [datetime.year, datetime.month, datetime.day, datetime.hour]
      |> Enum.map(fn x ->
        Integer.to_string(x)
      end)
      |> Enum.join("-")

    minute = Integer.to_string(datetime.minute)

    formated_minute =
      case minute |> String.length() do
        1 ->
          minute <> "0"

        _ ->
          minute
      end

    formated <> ":" <> formated_minute
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
      x.location
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
        speed when speed in ["--", "-", "", nil] ->
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
