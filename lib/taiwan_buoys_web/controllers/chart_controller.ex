defmodule TaiwanBuoysWeb.ChartController do
  use TaiwanBuoysWeb, :controller

  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoys.DataSources
  alias TaiwanBuoys.TideDataServer
  alias TaiwanBuoys.ForecastScraper.ForecastDataServer
  #  alias TaiwanBuoys.WeatherDataServer

  def index(conn, %{"location" => location}) do
    locations = DataSources.get_locations()
    %{lat: lat, lng: lng} = DataSources.get_location_lat_lng(location)

    conn
    |> assign(:choosen_location, location)
    |> assign(:lat, lat)
    |> assign(:lng, lng)
    |> assign(:location, location)
    |> assign(:location_options, locations)
    |> assign(:data, BuoyDataServer.view_location_data(location))
    |> assign(:tide_data, TideDataServer.view_location_data(location))
    |> assign(:forecast_data, ForecastDataServer.view_location_data(location))
    # |> assign(:prediction_data, WeatherDataServer.view_location_data(location))
    |> assign(:wave_title, String.capitalize(location) <> " Wave Data For Last 48hrs")
    |> assign(:wind_title, String.capitalize(location) <> " Wind Data For Last 48hrs")
    |> assign(:tide_title, String.capitalize(location) <> " Tide Data")
    |> assign(:forecast_title, String.capitalize(location) <> " Forecast Data")
    |> assign(:wave_pred_title, String.capitalize(location) <> " Wave Forecast")
    |> assign(:wind_pred_title, String.capitalize(location) <> " Wind Forecast")
    |> render("index.html")
  end
end
