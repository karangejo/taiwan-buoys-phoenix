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
    Process.send(self(), :initialize, [])

    {:ok, :ok}
  end

  def handle_info(:initialize, _) do
    # Do the desired work here
    case System.get_env("DEV_ENV") do
      "local" ->
        taitung_data = Weather.get_sample_taitung_data()
        WeatherDataServer.put_data_location("taitung", taitung_data)
      _ ->
        Weather.get_all_weather_data(&WeatherDataServer.put_data_location/2)
        # schedule work
        schedule_work()
    end

    {:noreply, :ok}
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
