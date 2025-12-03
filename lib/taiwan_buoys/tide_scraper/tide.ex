defmodule TaiwanBuoys.Tide do
  alias TaiwanBuoys.Tide.TideData
  alias TaiwanBuoys.DataSources

  require Logger

  def get_all_tide_data(persist_func) do
    DataSources.buoy_data()
    |> Enum.map(fn x ->
      Process.sleep(5000)
      get_tide_data(x.name, x.tide_url, persist_func)
    end)
  end

  def get_tide_data(location, url, persist_func) do
    case get_rows(url) do
      {:ok, rows} ->
        tide_data =
          rows
          |> get_data_from_row()
          |> Enum.take(-10)

        persist_func.(location, tide_data)

      error ->
        Logger.error(
          "Error getting tide data for location: #{location}, error: #{inspect(error)}"
        )

        error
    end
  end

  def get_rows(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        [{"tbody", _, table_rows}] =
          body
          |> Floki.parse_document!()
          |> Floki.find("tbody")

        {:ok, table_rows}

      error ->
        error
    end
  end

  def get_data_from_row(row) do
    row
    |> Enum.map(fn row ->
      {"tr", _, r} = row
      Enum.map(r, &Floki.text/1)
    end)
    |> Enum.reduce(%{date: "", data: []}, fn elem, acc ->
      if length(elem) == 6,
        do: %{acc | date: Enum.at(elem, 0), data: [elem | acc.data]},
        else: %{acc | data: [[acc.date | elem] | acc.data]}
    end)
    |> Map.get(:data)
    |> Enum.map(fn [first_elem | rest] ->
      [date, _, _, _, _, range] = String.split(first_elem)
      row = [date, range] ++ rest
      to_tide_data_struct(row)
    end)
  end

  def to_tide_data_struct(row) do
    height = Enum.at(row, 6)
    time = "#{Enum.at(row, 0)} #{Enum.at(row, 3)}" |> parse_date()
    type = "#{Enum.at(row, 1)} #{Enum.at(row, 2)}"
    %TideData{height: height, time: time, type: type}
  end

  def parse_date(date_str) do
    [month | [day | [hour | [minute]]]] =
      date_str
      |> String.replace(~r/[\s:]/, "/")
      |> String.split("/")
      |> Enum.map(fn x -> String.to_integer(x) end)

    year =
      DateTime.utc_now()
      |> Map.fetch!(:year)

    date = Date.new!(year, month, day)
    time = Time.new!(hour, minute, 0)
    DateTime.new!(date, time, "Asia/Taipei")
  end

  def get_sample_taitung_data() do
    File.read!("taitung_tide_data.txt")
    |> :erlang.binary_to_term()
  end
end
