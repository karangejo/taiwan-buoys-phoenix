defmodule TaiwanBuoys.TideDataServer do
  @moduledoc """
  this module is responsible for keeping
  the tide data
  """
  use GenServer

  alias TaiwanBuoys.Tide
  alias TaiwanBuoys.Scraper

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: TideDataServer)
  end

  def put_data(data) do
    GenServer.call(TideDataServer, {:put_data, data})
  end

  def put_data_location(location, data) do
    GenServer.call(TideDataServer, {:put_data_location, location, data})
  end

  def view_data do
    GenServer.call(TideDataServer, :view_data)
  end

  def view_location_data(location) do
    GenServer.call(TideDataServer, {:view_location_data, location})
  end

  # Server (callbacks)

  @impl true
  def init(init_data) do
    {:ok, init_data, {:continue, :initialize}}
  end

  @impl true
  def handle_continue(:initialize, current_data) do
      case System.get_env("DEV_ENV") do
        "local" ->
          buoy_data = Tide.get_sample_taitung_data()
          updated_data = Map.put(current_data, "taitung", buoy_data)
          {:noreply, updated_data }

        _ ->
          Task.start(fn -> Tide.get_all_tide_data(&__MODULE__.put_data_location/2) end)

          updated_data =
            Enum.map(Scraper.get_locations, fn x ->
              {x, []}
            end)
            |> Enum.into(%{})

          {:noreply, updated_data}
      end
  end

  @impl true
  def handle_call({:put_data, data}, _from, _state) do
    {:reply, data, data}
  end

  @impl true
  def handle_call({:put_data_location, location, data}, _from, current_data) do
    updated_data = Map.put(current_data, location, data)
    {:reply, updated_data, updated_data}
  end

  @impl true
  def handle_call(:view_data, _from, data) do
    {:reply, data, data}
  end

  @impl true
  def handle_call({:view_location_data, location}, _from, data) do
    {:reply, data[location], data}
  end
end
