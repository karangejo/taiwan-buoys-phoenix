defmodule TaiwanBuoys.Scraper do
  @moduledoc """
  Documentation for Scraper.
  """

  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.Scraper.BuoyData

  require Logger

  # Scraper
  def get_all_buoy_data(persist_func) do
    Enum.map(DataSources.buoy_data(), fn x ->
      Process.sleep(5000)
      get_buoy_data(x.name, x.url, persist_func)
    end)
  end

  def get_buoy_data(location, url, persist_func) do
    case get_rows(url) do
      {:ok, rows} ->
        buoy_data =
          rows
          |> Enum.map(fn x ->
            row = get_html_row(x)
            get_data_from_row(row)
          end)

        persist_func.(location, buoy_data)
        Logger.info("Successfully saved buoy data for location: #{location}")
        buoy_data

      {:error, _} = error ->
        Logger.error(
          "Error getting buoy data for location: #{location}, error: #{inspect(error)}"
        )

        []
    end
  end

  def get_latest_row(data) do
    [first_row = %BuoyData{} | rem_data] = data

    if first_row.wave_height == "-" or first_row.mean_wind_speed == "-" do
      get_latest_row(rem_data)
    else
      first_row
    end
  end

  def get_html_row(raw_row) do
    {"tr", _, row} = raw_row
    row
  end

  def get_rows(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Floki.parse_document!(body)}

      error ->
        error
    end
  end

  def get_data_from_row(row) do
    row
    |> get_text()
    |> clean_row()
  end

  def get_text(row) do
    Enum.map(row, fn x -> Floki.text(x) end)
  end

  def clean_row(row_list) do
    row_list
    |> rm_spaces_new_lines()
    |> label_and_clean()
    |> Enum.into(%{})
    |> to_buoy_data_struct()
  end

  def to_buoy_data_struct(row_map) do
    struct(%BuoyData{}, row_map)
  end

  def rm_spaces_new_lines(row) do
    Enum.map(row, fn x ->
      x
      |> String.replace("\n", "")
      |> String.replace(" ", "")
    end)
  end

  def label_and_clean(row) do
    row
    |> Enum.with_index()
    |> Enum.map(fn {elem, index} ->
      case index do
        0 ->
          {:date_time, parse_date(elem)}

        1 ->
          {:tidal_height, elem}

        2 ->
          {:wave_height, elem}

        3 ->
          {:wave_direction, half_string(elem)}

        4 ->
          {:wave_period, elem}

        5 ->
          {:mean_wind_speed, elem}

        6 ->
          {:wind_direction, half_string(elem)}

        7 ->
          {:maximum_wind, elem}

        8 ->
          {:water_temp_celcius, elem}

        9 ->
          {:air_temp_celcius, elem}

        10 ->
          {:pressure, elem}

        11 ->
          {:current_direction, half_string(elem)}

        12 ->
          {:current_speed, elem}
      end
    end)
  end

  def half_string(str) do
    String.slice(str, 0, round(String.length(str) / 2))
  end

  def parse_date(date_str) do
    [month | [day | [hour | [minute]]]] =
      date_str
      |> String.replace(~r/\([^0]+\)/, "/")
      |> String.replace(":", "/")
      |> String.split("/")
      |> Enum.map(fn x -> String.to_integer(x) end)

    year =
      DateTime.utc_now()
      |> Map.fetch!(:year)

    date = Date.new!(year, month, day)
    time = Time.new!(hour, minute, 0)
    DateTime.new!(date, time, "Asia/Taipei")
  end

  def get_sample_taitung_data() do
    File.read!("taitung_buoy_data.txt")
    |> :erlang.binary_to_term()
  end
end
