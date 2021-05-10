defmodule TaiwanBuoys.TideServer do
  @moduledoc """
  this module is responsible for periodically getting tide data
  """
  use GenServer

  alias TaiwanBuoys.Tide
  alias TaiwanBuoys.TideDataServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: TideServer)
  end

  @impl true
  def init(_) do
    # Schedule work to be performed on start
    Tide.get_all_tide_data(&TideDataServer.put_data_location/2)
    schedule_work()

    {:ok, :ok}
  end

  @impl true
  def handle_info(:work, _) do
    # Do the desired work here
    Tide.get_all_tide_data(&TideDataServer.put_data_location/2)
    # Reschedule once more
    schedule_work()

    {:noreply, :ok}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.hours(24))
  end
end
