defmodule TaiwanBuoysWeb.HomeController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoysWeb.Plugs.SetLocale

  def index(conn, _params) do
    {:ok, locale} = SetLocale.get_locale(conn)
    locations = DataSources.get_locations(locale)
    latest_data = BuoyDataServer.view_latest_data_all_buoys()
    wave_label = get_wave_label(locale)
    wind_label = get_wind_label(locale)
    select_buoy_label = get_select_buoy_label(locale)
    view_buoy_graph_label = get_view_buoy_graph_label(locale)
    view_chart_label = get_view_chart_label(locale)
    view_table_label = get_view_table_label(locale)
    wave_period_seconds = get_wave_period_seconds(locale)
    wave_height_meters = get_wave_height_meters(locale)
    wind_speed_knots = get_wind_speed_knots(locale)

    conn
    |> assign(:location, hd(locations) |> elem(1))
    |> assign(:locale, locale)
    |> assign(:location_options, locations)
    |> assign(:wave_title, wave_label)
    |> assign(:wind_title, wind_label)
    |> assign(:latest_data, latest_data)
    |> assign(:select_buoy_label, select_buoy_label)
    |> assign(:view_buoy_graph_label, view_buoy_graph_label)
    |> assign(:view_chart_label, view_chart_label)
    |> assign(:view_table_label, view_table_label)
    |> assign(:wave_period_seconds, wave_period_seconds)
    |> assign(:wave_height_meters, wave_height_meters)
    |> assign(:wind_speed_knots, wind_speed_knots)
    |> render("index.html")
  end

  def redirect_chart(conn, %{"location" => location}) do
    conn
    |> redirect(to: Routes.chart_path(conn, :index, location))
  end

  defp get_wave_period_seconds("en"), do: "Wave Period (seconds)"
  defp get_wave_period_seconds("zh-TW"), do: "波浪週期（秒）"
  defp get_wave_height_meters("en"), do: "Wave Height (meters)"
  defp get_wave_height_meters("zh-TW"), do: "波高（米）"
  defp get_wind_speed_knots("en"), do: "Wind Speed (knots)"
  defp get_wind_speed_knots("zh-TW"), do: "風速（節）"
  defp get_wave_label("en"), do: "Latest Wave Data"
  defp get_wave_label("zh-TW"), do: "最新波浪資料"
  defp get_wind_label("en"), do: "Latest Wind Data"
  defp get_wind_label("zh-TW"), do: "最新風速資料"
  defp get_select_buoy_label("en"), do: "Please Select a Buoy"
  defp get_select_buoy_label("zh-TW"), do: "請選擇一個浮標"
  defp get_view_buoy_graph_label("en"), do: "View Buoy Graph"
  defp get_view_buoy_graph_label("zh-TW"), do: "查看浮標圖表"
  defp get_view_chart_label("en"), do: "View Latest Buoy Chart"
  defp get_view_chart_label("zh-TW"), do: "查看最新浮標圖表"
  defp get_view_table_label("en"), do: "View Latest Buoy Table"
  defp get_view_table_label("zh-TW"), do: "查看最新浮標表格"
end
