defmodule TaiwanBuoys.DataSupervisor do
  use Supervisor

  alias TaiwanBuoys.WeatherDataServer
  alias TaiwanBuoys.TideDataServer
  alias TaiwanBuoys.BuoyDataServer

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {BuoyDataServer, []},
      {TideDataServer, []}
      # {WeatherDataServer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
