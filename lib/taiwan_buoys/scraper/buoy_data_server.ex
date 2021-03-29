defmodule TaiwanBuoys.BuoyDataServer do
  @moduledoc """
  this module is responsible for keeping
  the current buoy data
  """
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, "", name: BuoyDataServer)
  end

  def put_data(data) do
    GenServer.call(BuoyDataServer, {:put_data, data})
  end

  def view_data do
    GenServer.call(BuoyDataServer, :view_data)
  end

  def view_location_data(location) do
    GenServer.call(BuoyDataServer, {:view_location_data, location})
  end

  # Server (callbacks)

  @impl true
  def init(init_data) do
    {:ok, init_data}
  end

  @impl true
  def handle_call({:put_data, data}, _from, _state) do
    {:reply, data, data }
  end

  @impl true
  def handle_call(:view_data, _from, data) do
    {:reply, data, data}
  end

  @impl true
  def handle_call({:view_location_data, location}, _from, data) do
    {:reply, Enum.take(data[location], 48), data}
  end

end
