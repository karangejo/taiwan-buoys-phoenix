defmodule TaiwanBuoysWeb.ChartController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.TideDataServer
  alias TaiwanBuoys.ForecastScraper.ForecastDataServer
  alias TaiwanBuoysWeb.Plugs.SetLocale
  #  alias TaiwanBuoys.WeatherDataServer

  def index(conn, %{"location" => location}) do
    {:ok, locale} = SetLocale.get_locale(conn)
    locations = DataSources.get_locations(locale)
    location_name = DataSources.get_location_name(location, locale)
    %{lat: lat, lng: lng} = DataSources.get_location_lat_lng(location)

    wave_label = get_wave_label(locale)
    wind_label = get_wind_label(locale)
    tide_label = get_tide_label(locale)
    forecast_label = get_forecast_label(locale)
    wave_forecast_label = get_wave_forecast_label(locale)
    wind_forecast_label = get_wind_forecast_label(locale)
    view_buoy_graph = get_view_buoy_graph_label(locale)
    view_chart_label = get_view_chart_label(locale)
    view_table_label = get_view_table_label(locale)
    latitude_label = get_latitude_label(locale)
    longitude_label = get_longitude_label(locale)
    wave_period_seconds = get_wave_period_seconds(locale)
    wave_height_meters = get_wave_height_meters(locale)
    wind_speed_knots = get_wind_speed_knots(locale)
    tide_centimeters = get_tide_centimeters(locale)

    conn
    |> assign(:choosen_location, location)
    |> assign(:locale, locale)
    |> assign(:lat, lat)
    |> assign(:lng, lng)
    |> assign(:location, location)
    |> assign(:location_options, locations)
    |> assign(:data, BuoyDataServer.view_location_data(location))
    |> assign(:tide_data, TideDataServer.view_location_data(location))
    |> assign(:forecast_data, ForecastDataServer.view_location_data(location))
    |> assign(:wave_label, wave_label)
    |> assign(:wind_label, wind_label)
    |> assign(:tide_label, tide_label)
    |> assign(:forecast_label, forecast_label)
    |> assign(:wave_forecast_label, wave_forecast_label)
    |> assign(:wind_forecast_label, wind_forecast_label)
    |> assign(:view_buoy_graph, view_buoy_graph)
    |> assign(:view_chart_label, view_chart_label)
    |> assign(:view_table_label, view_table_label)
    |> assign(:latitude_label, latitude_label)
    |> assign(:longitude_label, longitude_label)
    |> assign(:wave_period_seconds, wave_period_seconds)
    |> assign(:wave_height_meters, wave_height_meters)
    |> assign(:wind_speed_knots, wind_speed_knots)
    |> assign(:tide_centimeters, tide_centimeters)
    # |> assign(:prediction_data, WeatherDataServer.view_location_data(location))
    |> assign(:wave_title, location_name <> " " <> wave_label)
    |> assign(:wind_title, location_name <> " " <> wind_label)
    |> assign(:tide_title, location_name <> " " <> tide_label)
    |> assign(:forecast_title, location_name <> " " <> forecast_label)
    |> assign(:wave_pred_title, location_name <> " " <> wave_forecast_label)
    |> assign(:wind_pred_title, location_name <> " " <> wind_forecast_label)
    |> render("index.html")
  end

  defp get_tide_centimeters("en"), do: "Tide (centimeters)"
  defp get_tide_centimeters("zh-TW"), do: "潮高（厘米）"
  defp get_wind_speed_knots("en"), do: "Wind Speed (knots)"
  defp get_wind_speed_knots("zh-TW"), do: "風速（節）"
  defp get_wave_height_meters("en"), do: "Wave Height (meters)"
  defp get_wave_height_meters("zh-TW"), do: "波高（米）"
  defp get_wave_period_seconds("en"), do: "Wave Period (seconds)"
  defp get_wave_period_seconds("zh-TW"), do: "波浪週期（秒）"
  defp get_latitude_label("en"), do: "Latitude"
  defp get_latitude_label("zh-TW"), do: "緯度"
  defp get_longitude_label("en"), do: "Longitude"
  defp get_longitude_label("zh-TW"), do: "經度"
  defp get_view_chart_label("en"), do: "View Buoy Chart"
  defp get_view_chart_label("zh-TW"), do: "查看浮標圖表"
  defp get_view_table_label("en"), do: "View Buoy Table"
  defp get_view_table_label("zh-TW"), do: "查看浮標表格"
  defp get_view_buoy_graph_label("en"), do: "View Buoy Graph"
  defp get_view_buoy_graph_label("zh-TW"), do: "查看浮標圖表"
  defp get_wave_label("en"), do: "Wave Data for Last 48hrs"
  defp get_wave_label("zh-TW"), do: "過去48小時波浪資料"
  defp get_wind_label("en"), do: "Wind Data for Last 48hrs"
  defp get_wind_label("zh-TW"), do: "過去48小時風速資料"
  defp get_tide_label("en"), do: "Tide Data"
  defp get_tide_label("zh-TW"), do: "潮汐資料"
  defp get_forecast_label("en"), do: "Forecast Data"
  defp get_forecast_label("zh-TW"), do: "預報資料"
  defp get_wave_forecast_label("en"), do: "Wave Forecast"
  defp get_wave_forecast_label("zh-TW"), do: "波浪預報"
  defp get_wind_forecast_label("en"), do: "Wind Forecast"
  defp get_wind_forecast_label("zh-TW"), do: "風速預報"
end
