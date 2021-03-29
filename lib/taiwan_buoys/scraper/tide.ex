defmodule TaiwanBuoys.Tide do

  @base_url "https://api.stormglass.io/v2/tide/extremes/point?"

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
      Authorization: System.fetch_env!("TIDE_API_KEY")
    }

    url = @base_url <> query

    HTTPoison.get!(url, header)
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
