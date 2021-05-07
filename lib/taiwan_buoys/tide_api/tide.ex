defmodule TaiwanBuoys.Tide do

  alias TaiwanBuoys.Scraper
  alias TaiwanBuoys.TideDataServer
  alias TaiwanBuoys.Tide.TideData

  @base_url "https://api.stormglass.io/v2/tide/extremes/point?"

  def get_all_tide_data() do
    Scraper.get_locations_data()
    |> Enum.map(fn x ->
      Process.sleep(5000)

      data =
        get_tide_data_from_lat_long(x.latitude, x.longitude)
        |> Enum.map(fn x -> TideData.from_map(x) end)

      TideDataServer.put_data_location(x.name, data)
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

    res = HTTPoison.get!(url, header)
    body = Jason.decode!(res.body)
    data = body["data"]

    Enum.map(data, fn x ->
      %{x | "time" => clean_date(x["time"])}
    end)
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


end
