defmodule TaiwanBuoys.WeatherServer do
  @moduledoc """
  this module is responsible for periodically getting weather data
  """
  use GenServer

  alias TaiwanBuoys.Weather
  alias TaiwanBuoys.WeatherDataServer


  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: WeatherServer)
  end

  @impl true
  def init(_) do
    # Schedule work to be performed on start
    Weather.get_all_weather_data(&WeatherDataServer.put_data_location/2)
    schedule_work()

    {:ok, :ok}
  end

  @impl true
  def handle_info(:work, _) do
    # Do the desired work here
    Weather.get_all_weather_data(&WeatherDataServer.put_data_location/2)
    # Reschedule once more
    schedule_work()

    {:noreply, :ok}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.hours(24))
  end
end
