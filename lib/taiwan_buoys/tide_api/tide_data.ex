defmodule TaiwanBuoys.Tide.TideData do
  defstruct [
    :height,
    :time,
    :type
  ]

  def from_map(%{"height" => height, "time" => time, "type" => type}) do
    %__MODULE__{height: height, time: time, type: type}
  end

  def from_map(atom_map) do
    struct(%__MODULE__{}, atom_map)
  end

end
