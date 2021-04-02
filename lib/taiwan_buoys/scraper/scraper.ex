defmodule TaiwanBuoys.Scraper do
  @moduledoc """
  Documentation for Scraper.
  """

  alias Wallaby.Browser
  alias TaiwanBuoys.BuoyDataServer

  @buoy_urls [
    %{
      name: "taitung",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=WRA007",
      longitude: 121.1442,
      latitude: 22.7242
    },
    %{
      name: "hualien",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46699A",
      longitude: 121.6325,
      latitude: 24.0311
    },
    %{
      name: "lanyu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6S94",
      longitude: 121.5828,
      latitude: 22.0753
    },
    %{
      name: "guishandao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46708A",
      longitude: 121.9256,
      latitude: 24.8469
    },
    %{
      name: "mituo",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=COMC08",
      longitude: 120.165,
      latitude: 22.7653
    },
    %{
      name: "suao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46706A",
      longitude: 121.8761,
      latitude: 24.6256
    },
    %{
      name: "penghu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46735A",
      longitude: 119.5519,
      latitude: 23.7283
    },
    %{
      name: "matsu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6W08",
      longitude: 120.5153,
      latitude: 26.3525
    },
    %{
      name: "kinmen",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46787A",
      longitude: 118.4153,
      latitude: 24.3797
    },
    %{
      name: "erluanbi",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46759A",
      longitude: 120.8158,
      latitude: 21.9183
    },
    %{
      name: "xiaoliuqiu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46714D",
      longitude: 120.3583,
      latitude: 22.3114
    },
    %{
      name: "hsinchu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46757B",
      longitude: 120.8422,
      latitude: 24.7625
    },
    %{
      name: "longdong",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46694A",
      longitude: 121.9222,
      latitude: 25.0969
    },
    %{
      name: "fuguicape",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6AH2",
      longitude: 121.5336,
      latitude: 25.3036
    },
    %{
      name: "pengjiayu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6B01",
      longitude: 122.0588,
      latitude: 25.6049
    }
  ]

  def get_locations_data do
    @buoy_urls
  end

  def get_location_lat_lng(location) do
    %{latitude: lat, longitude: lng} = Enum.find(@buoy_urls, fn x -> x.name == location end)
    %{lat: lat, lng: lng}
  end

  def get_locations do
    Enum.map(@buoy_urls, fn x -> x.name end)
  end

  def get_rows(url) do
    case Wallaby.start_session() do
      {:ok, session} ->
        table_list =
          session
          |> Browser.visit(url)
          |> Browser.page_source()
          |> Floki.parse_document!()
          |> Floki.find("tbody")

        Wallaby.end_session(session)
        {"tbody", _, tbody} = hd(table_list)
        {:ok, tbody}

      _ ->
        {:error, "could not get rows"}
    end
  end

  def get_data_from_row(row) do
    row
    |> Enum.map(fn x -> Floki.text(x) end)
    |> clean_row()
  end

  def get_buoy_data(location, url) do
    buoy_data =
      case get_rows(url) do
        {:ok, rows} ->
          rows
          |> Enum.map(fn x ->
            {"tr", _, row} = x
            get_data_from_row(row)
          end)

        {:error, _} ->
          []
      end

    BuoyDataServer.put_data_location(location, buoy_data)
  end

  def clean_row(row_list) do
    row_list
    |> Enum.map(fn x ->
      x
      |> String.replace("\n", "")
      |> String.replace(" ", "")
    end)
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
    |> Enum.into(%{})
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

  def get_all_buoy_data do
    Enum.map(@buoy_urls, fn x ->
      Process.sleep(5000)
      get_buoy_data(x.name, x.url)
    end)
  end
end
