defmodule TaiwanBuoys.Scraper do
  @moduledoc """
  Documentation for Scraper.
  """

  alias Wallaby.Browser
  alias TaiwanBuoys.Scraper.BuoyData

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

  # Data accesors
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


  # Scraper
  def get_all_buoy_data(persist_func, wave_notify_func, wind_notify_func) do
    Enum.map(@buoy_urls, fn x ->
      Process.sleep(5000)
      get_buoy_data(x.name, x.url, persist_func, wave_notify_func, wind_notify_func)
    end)
  end

  def get_buoy_data(location, url, persist_func, wave_notify_func, wind_notify_func) do
    case get_rows(url) do
      {:ok, rows} ->
        buoy_data =
          rows
          |> Enum.map(fn x ->
            row =  get_html_row(x)
            get_data_from_row(row)
          end)

        latest_row = get_latest_row(buoy_data)
        wave_notify_func.(location, latest_row)
        wind_notify_func.(location, latest_row)
        persist_func.(location, buoy_data)
        buoy_data
      {:error, _} ->
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
    |> Enum.map( fn {elem, index} ->
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
    |> :erlang.binary_to_term
  end

end
