defmodule TaiwanBuoys.ScraperServer do
  @moduledoc """
  this module is responsible for periodically getting the buoy data
  """
  use GenServer

  alias TaiwanBuoys.BuoyDataServer
  alias TaiwanBuoys.Scraper

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: ScraperServer)
  end

  @impl true
  def init(_) do
    # Schedule work to be performed on start
    case Scraper.get_all_buoy_data() do
      [] ->
        # if the data is empty then try again in 2 seconds
        Process.send_after(self(), :work, :timer.seconds(5))
      data ->
        BuoyDataServer.put_data(data)
    end
    schedule_work()
    {:ok, :ok}
  end

  @impl true
  def handle_info(:work, _) do
    # Do the desired work here
    case Scraper.get_all_buoy_data() do
      [] ->
        # if the data is empty then try again in 2 seconds
        Process.send_after(self(), :work, :timer.seconds(5))
      data ->
        BuoyDataServer.put_data(data)
    end
    # Reschedule once more
    schedule_work()

    {:noreply, :ok}
  end


  defp schedule_work do
    Process.send_after(self(), :work, :timer.minutes(30))
  end

end
