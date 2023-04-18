defmodule TaiwanBuoys.DataSources do
  @buoy_data [
    %{
      name: "taitung",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MWRA007.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001407.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001407C01.html?T=942",
      longitude: 121.1442,
      latitude: 22.7242
    },
    %{
      name: "hualien",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46699A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001506.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001508C01.html?T=17",
      longitude: 121.6325,
      latitude: 24.0311
    },
    %{
      name: "lanyu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6S94.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001416.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001416C02.html?T=709",
      longitude: 121.5828,
      latitude: 22.0753
    },
    %{
      name: "guishandao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46708A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000204.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1000204C01.html?T=756",
      longitude: 121.9256,
      latitude: 24.8469
    },
    %{
      name: "mituo",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MCOMC08.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T400028.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6402800C01.html?T=741",
      longitude: 120.165,
      latitude: 22.7653
    },
    %{
      name: "suao",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46706A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000203.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1000203C01.html?T=779",
      longitude: 121.8761,
      latitude: 24.6256
    },
    %{
      name: "penghu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46735A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001601.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001602C01.html?T=923",
      longitude: 119.5519,
      latitude: 23.7283
    },
    %{
      name: "matsu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6W08.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T900702.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/0900701C01.html?T=233",
      longitude: 120.5153,
      latitude: 26.3525
    },
    %{
      name: "kinmen",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46787A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T902004.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/0902004C01.html?T=543",
      longitude: 118.4153,
      latitude: 24.3797
    },
    %{
      name: "erluanbi",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46759A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001304.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001304C01.html?T=829",
      longitude: 120.8158,
      latitude: 21.9183
    },
    %{
      name: "xiaoliuqiu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46714D.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001322.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001322C02.html?T=110",
      longitude: 120.3583,
      latitude: 22.3114
    },
    %{
      name: "hsinchu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46757B.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000504.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001802C01.html?T=911",
      longitude: 120.8422,
      latitude: 24.7625
    },
    %{
      name: "longdong",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46694A.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500026.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502600C01.html?T=955",
      longitude: 121.9222,
      latitude: 25.0969
    },
    %{
      name: "fuguicape",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6AH2.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500022.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502200C01.html?T=191",
      longitude: 121.5336,
      latitude: 25.3036
    },
    %{
      name: "pengjiayu",
      url: "https://www.cwb.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6B01.html",
      tide_url: "https://www.cwb.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500010.html",
      forecast_url: "https://www.cwb.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502200C01.html?T=191",
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
