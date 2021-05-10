defmodule TaiwanBuoys.ScraperServer do
  @moduledoc """
  this module is responsible for periodically getting the buoy data
  """
  use GenServer

  alias TaiwanBuoys.Scraper
  alias TaiwanBuoys.BuoyDataServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: ScraperServer)
  end

  @impl true
  def init(_) do
    # Schedule work to be performed on start
    Scraper.get_all_buoy_data(&BuoyDataServer.put_data_location/2)
    schedule_work()

    {:ok, :ok}
  end

  @impl true
  def handle_info(:work, _) do
    # Do the desired work here
    Scraper.get_all_buoy_data(&BuoyDataServer.put_data_location/2)
    # Reschedule once more
    schedule_work()

    {:noreply, :ok}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.minutes(30))
  end
end
