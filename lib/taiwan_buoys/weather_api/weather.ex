defmodule TaiwanBuoys.Weather do

  alias TaiwanBuoys.Scraper

  @base_url "https://api.stormglass.io/v2/weather/point?"
  @directions {"N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"}

  def degrees_to_direction(degree) do
    index = round(degree/22.5)
    elem(@directions, index)
  end

  def get_noaa_values_by_attribute(data, attr_name) do
    get_attribute_values_by_source(data, "noaa", attr_name)
  end

  def get_attribute_values_by_source(data, source, attr_name) do
    Enum.map(data, fn %{^attr_name => %{^source => value}} ->
      value
    end)
  end

  def get_all_weather_data(persist_func) do
    Scraper.get_locations_data()
    |> Enum.map(fn x ->
      Process.sleep(5000)

      case get_weather_data_from_lat_long(x.latitude, x.longitude) do
        [] ->
          []
        weather_data ->
          persist_func.(x.name, weather_data)
      end

    end)
  end

  def get_weather_data_from_lat_long(lat, long) do
    query =
      %{lat: lat, lng: long}
      |> URI.encode_query()

    header = %{
      Authorization: System.fetch_env!("STORM_GLASS_API_KEY")
    }

    params = "&params=swellDirection,swellHeight,swellPeriod,waveDirection,waveHeight,wavePeriod,windDirection,windSpeed,windWaveHeight,windWaveDirection,windWavePeriod"


    url = @base_url <> query <> params

    case HTTPoison.get(url, header) do
      {:ok, res} ->
        body = Jason.decode!(res.body)
        data = body["hours"]

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


  def get_sample_taitung_data() do
    File.read!("taitung_weather_data.txt")
    |> :erlang.binary_to_term
  end

end
