defmodule TaiwanBuoys.WeatherDataServer do
  @moduledoc """
  this module is responsible for keeping
  the weather data
  """
  use GenServer

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
    {:ok, init_data}
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
