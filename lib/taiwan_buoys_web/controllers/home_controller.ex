defmodule TaiwanBuoysWeb.HomeController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.DataSources

  def index(conn, _params) do
    locations = DataSources.get_locations()

    conn
    |> assign(:location, hd(locations))
    |> assign(:location_options, locations)
    |> render("index.html")
  end

  def redirect_chart(conn, %{"location" => location}) do
    conn
    |> redirect(to: Routes.chart_path(conn, :index, location))
  end
end
