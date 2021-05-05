defmodule TaiwanBuoysWeb.ChartController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoys.Scraper

  def index(conn, %{"location" => location}) do
    locations = Scraper.get_locations()
    %{lat: lat, lng: lng} = Scraper.get_location_lat_lng(location)

     conn
     |> assign(:choosen_location, location)
     |> assign(:lat, lat)
     |> assign(:lng, lng)
     |> assign(:location, location)
     |> assign(:location_options, locations)
     |> assign(:data, BuoyDataServer.view_location_data(location))
     |> assign(:wave_title, String.capitalize(location) <> " Wave Data For Last 48hrs")
     |> assign(:wind_title, String.capitalize(location) <> " Wind Data For Last 48hrs")
     |> render("index.html")
  end

end
