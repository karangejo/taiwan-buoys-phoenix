defmodule TaiwanBuoysWeb.GraphLive do
  use TaiwanBuoysWeb, :live_view

  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoys.Scraper

  @impl true
  def mount(%{"location" => location}, _session, socket) do
    locations =  Scraper.get_locations
    {:ok, socket
            |> assign(:choosen_location, location)
            |> assign(:location, location )
            |> assign(:location_options, locations)
            |> push_event("chart-data", %{data: BuoyDataServer.view_location_data(location)})
            |> push_event("wave-chart-label", %{label: String.capitalize(location) <> " Wave Data For Last 48hrs"})
            |> push_event("wind-chart-label", %{label: String.capitalize(location) <> " Wind Data For Last 48hrs"})
          }
  end

  @impl true
  def handle_params(%{"location" => location}, _uri, socket) do
    {:noreply, socket
            |> assign(:choosen_location, location)
            |> assign(:location, location )
            |> push_event("chart-data", %{data: BuoyDataServer.view_location_data(location)})
            |> push_event("wave-chart-label", %{label: String.capitalize(location) <> " Wave Data For Last 48hrs"})
            |> push_event("wind-chart-label", %{label: String.capitalize(location) <> " Wind Data For Last 48hrs"})
          }
  end

  @impl true
  def handle_event("update-location", %{"location" => location}, socket) do
    {:noreply, assign(socket, :choosen_location, location)}
  end

  @impl true
  def handle_event("view-buoy", _, socket) do
    {:noreply, redirect(socket, to: Routes.graph_path(socket, :show, socket.assigns.choosen_location))}
  end

end
