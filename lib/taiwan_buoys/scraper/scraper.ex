defmodule TaiwanBuoys.Scraper do
  @moduledoc """
  Documentation for Scraper.
  """

  alias Wallaby.Browser

  @buoy_urls [
    %{name: "taitung", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=WRA007"},
    %{name: "hualien", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46699A"},
    %{name: "lanyu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6S94"},
    %{name: "guishandao", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46708A"},
    %{name: "suao", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46706A"},
    %{name: "penghu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46735A"},
    %{name: "matsu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6W08"},
    %{name: "kinmen", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46787A"},
    %{name: "xiaoliuqiu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46714D"},
    %{name: "hsinchu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46757B"},
    %{name: "luodong", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=46694A"},
    %{name: "fugui_cape", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6AH2"},
    %{name: "pengjiayu", url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine_30day.html?MID=C6B01"}
  ]

  def get_locations do
    [
      "taitung",
      "hualien",
      "lanyu",
      "guishandao",
      "suao",
      "penghu",
      "matsu",
      "kinmen",
      "xiaoliuqiu",
      "hsinchu",
      "luodong",
      "fugui_cape",
      "pengjiayu"
    ]
  end

  def get_rows(url) do
    {:ok, session} = Wallaby.start_session()
    table_list =
      session
      |> Browser.visit(url)
      |> Browser.page_source()
      |> Floki.parse_document!()
      |> Floki.find("tbody")
    {"tbody", _, tbody} = hd table_list
    #{"tr", _, rows} = hd tbody
    tbody
  end

  def get_data_from_row(row) do
    row
    |> Enum.map(fn x -> Floki.text(x) end)
    |> clean_row()
  end

  def get_buoy_data(url) do
    url
    |> get_rows()
    |> Enum.map(fn x ->
      {"tr", _, row} = x
      get_data_from_row(row)
    end)
  end

  def clean_row(row_list) do
    row_list
    |> Enum.map(fn x ->
      x
      |> String.replace("\n","")
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
    String.slice(str,0, round(String.length(str)/2))
  end

  def parse_date(date_str) do
    [month | [day | [hour | [minute]]]] =
      date_str
      |> String.replace(~r/\([^0]+\)/, "/")
      |> String.replace(":","/")
      |> String.split("/")
      |> Enum.map(fn x -> String.to_integer(x) end)
    year =
      DateTime.utc_now
      |> Map.fetch!(:year)
    date = Date.new!(year, month, day)
    time = Time.new!(hour, minute, 0)
    DateTime.new!(date, time)
  end

  def get_all_buoy_data do
    Enum.map(@buoy_urls, fn x ->
      Process.sleep(2000)
      {x.name, get_buoy_data(x.url)}
    end)
    |> Enum.into(%{})
  end
end
