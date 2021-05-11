defmodule TaiwanBuoysWeb.ChartView do
  use TaiwanBuoysWeb, :view

  alias TaiwanBuoys.Weather

  def display_date_time(datetime) do
    formated =
      [datetime.year , datetime.month,  datetime.day,  datetime.hour]
      |> Enum.map(fn x ->
        Integer.to_string(x)
      end)
      |> Enum.join("-")

    minute = Integer.to_string(datetime.minute)
    formated_minute =
      case minute |> String.length do
        1 ->
          minute <> "0"
        _ ->
          minute
      end

    formated <> ":" <> formated_minute
  end

  def filter_dates(date_time_list, num_hrs) do
    date_time_list
    |> Enum.with_index()
    |> Enum.reduce([],  fn {value, index}, acc ->
      case rem(index, num_hrs) do
        0 ->
          [value | acc]
        _ ->
          acc
      end
    end)
  end


  def colorize_by_day(date_time_list) do
    date_time_list
    |> Enum.map(fn date_time ->
      case Calendar.ISO.day_of_week(date_time.year, date_time.month, date_time.day) do
        1 ->
          "blue"
        2 ->
          "green"
        3 ->
          "yellow"
        4 ->
          "orange"
        5 ->
          "red"
        6 ->
          "purple"
        7 ->
          "pink"
      end
    end)
  end

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
    |> Enum.map(fn x ->
      Float.to_string(x * 1.94384)
    end)
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
