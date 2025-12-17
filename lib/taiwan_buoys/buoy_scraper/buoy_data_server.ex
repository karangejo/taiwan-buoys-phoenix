defmodule TaiwanBuoys.BuoyDataServer do
  @moduledoc """
  this module is responsible for keeping
  the current buoy data
  """
  use GenServer

  alias TaiwanBuoys.{Scraper, DataSources}

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: BuoyDataServer)
  end

  def put_data(data) do
    GenServer.call(BuoyDataServer, {:put_data, data})
  end

  def put_data_location(location, data) do
    GenServer.call(BuoyDataServer, {:put_data_location, location, data})
  end

  def view_data do
    GenServer.call(BuoyDataServer, :view_data)
  end

  def view_latest_data_all_buoys do
    GenServer.call(BuoyDataServer, :view_latest_data_all_buoys)
  end

  def view_location_data(location) do
    GenServer.call(BuoyDataServer, {:view_location_data, location})
  end

  # Server (callbacks)

  @impl true
  def init(init_data) do
    {:ok, init_data, {:continue, :initialize}}
  end

  @impl true
  def handle_continue(:initialize, current_data) do
    if Application.get_env(:taiwan_buoys, :local_dev) do
      buoy_data = Scraper.get_sample_taitung_data()
      updated_data = Map.put(current_data, "taitung", buoy_data)
      {:noreply, updated_data}
    else
      Task.start(fn ->
        Scraper.get_all_buoy_data(&__MODULE__.put_data_location/2)
      end)

      updated_data =
        Enum.map(DataSources.get_locations(), fn x ->
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
  def handle_call(:view_latest_data_all_buoys, _from, data) do
    latest_data =
      DataSources.get_locations()
      |> Enum.map(fn {location, _} ->
        data
        |> Map.get(location)
        |> get_latest()
        |> case do
          nil ->
            nil

          entry ->
            entry
            |> Map.put(:location, location)
        end
      end)
      |> Enum.reject(&is_nil/1)

    {:reply, latest_data, data}
  end

  @impl true
  def handle_call({:view_location_data, location}, _from, data) do
    {:reply, Enum.take(data[location], 48), data}
  end

  defp get_latest([]), do: nil

  defp get_latest(data) do
    [first | rest] = data

    first
    |> case do
      nil ->
        nil

      entry ->
        if entry.wave_height in ["-", "--", ""] do
          get_latest(rest)
        else
          entry
          |> Map.from_struct()
        end
    end
  end
end
