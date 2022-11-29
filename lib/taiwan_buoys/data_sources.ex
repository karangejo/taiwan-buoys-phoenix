defmodule TaiwanBuoys.DataSources do
  @buoy_data [
    %{
      name: "taitung",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MWRA007.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001415.html",
      longitude: 121.1442,
      latitude: 22.7242
    },
    %{
      name: "hualien",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46699A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001506.html",
      longitude: 121.6325,
      latitude: 24.0311
    },
    %{
      name: "lanyu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6S94.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001416.html",
      longitude: 121.5828,
      latitude: 22.0753
    },
    %{
      name: "guishandao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46708A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000204.html",
      longitude: 121.9256,
      latitude: 24.8469
    },
    %{
      name: "mituo",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MCOMC08.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T400028.html",
      longitude: 120.165,
      latitude: 22.7653
    },
    %{
      name: "suao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46706A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000203.html",
      longitude: 121.8761,
      latitude: 24.6256
    },
    %{
      name: "penghu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46735A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001601.html",
      longitude: 119.5519,
      latitude: 23.7283
    },
    %{
      name: "matsu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6W08.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T900702.html",
      longitude: 120.5153,
      latitude: 26.3525
    },
    %{
      name: "kinmen",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46787A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T902004.html",
      longitude: 118.4153,
      latitude: 24.3797
    },
    %{
      name: "erluanbi",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46759A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001304.html",
      longitude: 120.8158,
      latitude: 21.9183
    },
    %{
      name: "xiaoliuqiu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46714D.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001322.html",
      longitude: 120.3583,
      latitude: 22.3114
    },
    %{
      name: "hsinchu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46757B.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000504.html",
      longitude: 120.8422,
      latitude: 24.7625
    },
    %{
      name: "longdong",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46694A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500026.html",
      longitude: 121.9222,
      latitude: 25.0969
    },
    %{
      name: "fuguicape",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6AH2.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500022.html",
      longitude: 121.5336,
      latitude: 25.3036
    },
    %{
      name: "pengjiayu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6B01.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500010.html",
      longitude: 122.0588,
      latitude: 25.6049
    }
  ]

  def buoy_data, do: @buoy_data

  def get_locations, do: Enum.map(@buoy_data, &Map.get(&1, :name))

  def get_location_lat_lng(location) do
    %{latitude: lat, longitude: lng} = Enum.find(@buoy_data, fn x -> x.name == location end)

    %{lat: lat, lng: lng}
  end
end
