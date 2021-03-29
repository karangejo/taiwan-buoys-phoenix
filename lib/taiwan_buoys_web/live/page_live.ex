defmodule TaiwanBuoysWeb.PageLive do
  use TaiwanBuoysWeb, :live_view

  alias TaiwanBuoys.Scraper

  @impl true
  def mount(_params, _session, socket) do
    locations =  Scraper.get_locations
    {:ok, socket
            |> assign(:location, hd locations )
            |> assign(:location_options, locations)
          }
  end

  @impl true
  def handle_event("update-location", %{"location" => location}, socket) do
    {:noreply, assign(socket, :location, location)}
  end

  @impl true
  def handle_event("view-buoy", _, socket) do
    {:noreply, push_redirect(socket, to: Routes.graph_path(socket, :show, socket.assigns.location))}
  end

end
