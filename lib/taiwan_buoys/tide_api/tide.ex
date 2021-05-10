defmodule TaiwanBuoys.Tide do

  alias TaiwanBuoys.Scraper
  alias TaiwanBuoys.Tide.TideData

  @base_url "https://api.stormglass.io/v2/tide/extremes/point?"

  def get_all_tide_data(persist_func) do
    Scraper.get_locations_data()
    |> Enum.map(fn x ->
      Process.sleep(5000)

      case get_tide_data_from_lat_long(x.latitude, x.longitude) do
        [] ->
          []
        tide_data ->
          data = Enum.map(tide_data, fn x -> TideData.from_map(x) end)
          persist_func.(x.name, data)
      end

    end)
  end

  def get_tide_data_from_lat_long(lat, long) do
    query =
      %{
        lat: lat,
        lng: long,
        start: get_date_offset_from_today(-3),
        end: get_date_offset_from_today(3),
      }
      |> URI.encode_query()

    header = %{
      Authorization: System.fetch_env!("STORM_GLASS_API_KEY")
    }

    url = @base_url <> query

    case HTTPoison.get(url, header) do
      {:ok, res} ->
        body = Jason.decode!(res.body)
        data = body["data"]

        Enum.map(data, fn x ->
          %{x | "time" => clean_date(x["time"])}
        end)
      {:error, _} ->
        []
    end
  end

  defp clean_date(datetime_string) do
    {:ok, date_time, _} = DateTime.from_iso8601(datetime_string)
    DateTime.shift_zone!(date_time, "Asia/Taipei")
  end

  defp get_date_offset_from_today(offset) do
        Date.utc_today()
        |> Date.add(offset)
        |> Date.to_string()
  end

  def get_sample_taitung_data() do
    File.read!("taitung_tide_data.txt")
    |> :erlang.binary_to_term
  end


end
