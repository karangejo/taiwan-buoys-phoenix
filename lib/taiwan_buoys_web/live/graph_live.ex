defmodule TaiwanBuoysWeb.GraphLive do
  use TaiwanBuoysWeb, :live_view

  alias TaiwanBuoys.BuoyDataServer

  @impl true
  def mount(%{"location" => location}, _session, socket) do
    {:ok, socket
            |> assign(:location, location)
            |> push_event("chart-data", %{data: BuoyDataServer.view_location_data(location)})
            |> push_event("chart-label", %{label: location})
          }
  end

end
