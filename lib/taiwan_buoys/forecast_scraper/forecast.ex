defmodule TaiwanBuoys.ForecastScraper.Forecast do
  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.ForecastScraper.ForecastData

  require Logger

  def get_all_forecast_data(persist_func) do
    DataSources.buoy_data()
    |> Enum.map(fn x ->
      Process.sleep(5000)
      get_forecast_data(x.name, x.forecast_url, persist_func)
    end)
  end

  def get_forecast_data(location, url, persist_func) do
    case get_rows(url) do
      {:ok, rows} ->
        forecast_data =
          rows
          |> get_data_from_rows()

        persist_func.(location, forecast_data)
        Logger.info("Successfully saved forecast data for location: #{location}")
        forecast_data

      error ->
        Logger.error(
          "Error getting forecast data for location: #{location}, error: #{inspect(error)}"
        )

        error
    end
  end

  def get_rows(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok,
         body
         |> Floki.parse_document!()}

      error ->
        error
    end
  end

  def get_data_from_rows(rows) do
    rows
    |> Enum.map(fn row ->
      {"tr", _, r} = row
      at = if length(r) == 11, do: 2, else: 1

      {"td", _, knots_elem} = Enum.at(r, at)

      knots =
        knots_elem
        |> Enum.at(1)
        |> Floki.text()

      r
      |> Enum.map(&Floki.text/1)
      |> List.insert_at(-1, knots)
    end)
    |> Enum.reduce(%{date: "", data: []}, fn elem, acc ->
      if length(elem) == 12 do
        date = Enum.at(elem, 0)
        %{acc | date: date, data: [elem | acc.data]}
      else
        %{acc | data: [[acc.date | elem] | acc.data]}
      end
    end)
    |> Map.get(:data)
    |> Enum.reverse()
    |> Enum.map(&to_forecast_struct/1)
  end

  def to_forecast_struct(row) do
    [date, time, _, _, wind_dir, wave_height, wave_dir, period, _, _, _, wind_speed] = row

    %ForecastData{
      date_time: parse_date_time(date, time),
      wave_direction: wave_dir,
      wave_height: wave_height,
      wave_period: period,
      wind_direction: wind_dir,
      wind_speed: wind_speed
    }
  end

  def parse_date_time(date_str, time_str) do
    [month, day] =
      date_str
      |> String.split("\n")
      |> Enum.at(0)
      |> String.split("/")
      |> Enum.map(fn x -> String.to_integer(x) end)

    [hour, minute] =
      time_str
      |> String.split(":")
      |> Enum.map(fn x -> String.to_integer(x) end)

    now = DateTime.utc_now()
    current_year = now.year
    current_month = now.month

    year =
      cond do
        current_month == 1 and month == 12 -> current_year - 1
        current_month == 12 and month == 1 -> current_year + 1
        true -> current_year
      end

    date = Date.new!(year, month, day)
    time = Time.new!(hour, minute, 0)
    DateTime.new!(date, time, "Asia/Taipei")
  end

  def get_sample_taitung_data() do
    File.read!("taitung_forecast_data.txt")
    |> :erlang.binary_to_term()
  end
end
