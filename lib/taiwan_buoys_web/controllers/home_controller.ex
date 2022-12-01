defmodule TaiwanBuoysWeb.HomeController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.BuoyDataServer

  def index(conn, _params) do
    locations = DataSources.get_locations()
    latest_data = BuoyDataServer.view_latest_data_all_buoys()

    conn
    |> assign(:location, hd(locations))
    |> assign(:location_options, locations)
    |> assign(:wave_title, "Latest Wave Data")
    |> assign(:wind_title, "Latest Wind Data")
    |> assign(:latest_data, latest_data)
    |> render("index.html")
  end

  def redirect_chart(conn, %{"location" => location}) do
    conn
    |> redirect(to: Routes.chart_path(conn, :index, location))
  end
end
