defmodule TaiwanBuoys.DataSources do
  @buoy_data [
    %{
      name: "taitung",
      chinese_name: "台東",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MWRA007.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001407.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001407C01.html?T=942",
      longitude: 121.1442,
      latitude: 22.7222
    },
    %{
      name: "chengong",
      chinese_name: "成功",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46761F.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001402.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001402C01.html?T=729",
      longitude: 121.3799,
      latitude: 23.0972
    },
    %{
      name: "hualien",
      chinese_name: "花蓮",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46699A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001506.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001508C01.html?T=17",
      longitude: 121.6325,
      latitude: 24.0311
    },
    %{
      name: "lanyu",
      chinese_name: "蘭嶼",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6S94.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001416.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001416C02.html?T=709",
      longitude: 121.5828,
      latitude: 22.0753
    },
    %{
      name: "guishandao",
      chinese_name: "龜山島",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46708A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000204.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1000204C01.html?T=756",
      longitude: 121.9256,
      latitude: 24.8469
    },
    %{
      name: "mituo",
      chinese_name: "美濃",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MCOMC08.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T400028.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6402800C01.html?T=741",
      longitude: 120.165,
      latitude: 22.7653
    },
    %{
      name: "suao",
      chinese_name: "蘇澳",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46706A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000203.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1000203C01.html?T=779",
      longitude: 121.8761,
      latitude: 24.6256
    },
    %{
      name: "penghu",
      chinese_name: "澎湖",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46735A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001601.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001602C01.html?T=923",
      longitude: 119.5519,
      latitude: 23.7283
    },
    %{
      name: "matsu",
      chinese_name: "馬祖",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6W08.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T900702.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/0900701C01.html?T=233",
      longitude: 120.5153,
      latitude: 26.3525
    },
    %{
      name: "kinmen",
      chinese_name: "金門",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46787A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T902004.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/0902004C01.html?T=543",
      longitude: 118.4153,
      latitude: 24.3797
    },
    %{
      name: "erluanbi",
      chinese_name: "鵝鑾鼻",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46759A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001304.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001304C01.html?T=829",
      longitude: 120.8158,
      latitude: 21.9183
    },
    %{
      name: "xiaoliuqiu",
      chinese_name: "小琉球",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46714D.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T001322.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001322C02.html?T=110",
      longitude: 120.3583,
      latitude: 22.3114
    },
    %{
      name: "hsinchu",
      chinese_name: "新竹",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46757B.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T000504.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/1001802C01.html?T=911",
      longitude: 120.8422,
      latitude: 24.7625
    },
    %{
      name: "longdong",
      chinese_name: "龍洞",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/M46694A.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500026.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502600C01.html?T=955",
      longitude: 121.9222,
      latitude: 25.0969
    },
    %{
      name: "fuguicape",
      chinese_name: "富貴角",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6AH2.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500022.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502200C01.html?T=191",
      longitude: 121.5336,
      latitude: 25.3036
    },
    %{
      name: "pengjiayu",
      chinese_name: "彭佳嶼",
      url: "https://www.cwa.gov.tw/V8/E/M/OBS_Marine/48hrsSeaObs_MOD/MC6B01.html",
      tide_url: "https://www.cwa.gov.tw/V8/E/M/Fishery/tide_30day_MOD/T500010.html",
      forecast_url: "https://www.cwa.gov.tw/V8/E/M/TownCoastal/MOD/3hr/6502200C01.html?T=191",
      longitude: 122.0588,
      latitude: 25.6049
    }
  ]

  def buoy_data, do: @buoy_data

  def get_locations(locale \\ "en")
  def get_locations("en"), do: Enum.map(@buoy_data, &{Map.get(&1, :name), Map.get(&1, :name)})
  def get_locations("zh-TW"), do: Enum.map(@buoy_data, &{Map.get(&1, :chinese_name), Map.get(&1, :name)})

  def get_location_lat_lng(location) do
    %{latitude: lat, longitude: lng} = Enum.find(@buoy_data, fn x -> x.name == location end)

    %{lat: lat, lng: lng}
  end

  def get_location_name(location, "en") do
    %{name: name} = Enum.find(@buoy_data, fn x -> x.name == location end)
    String.capitalize(name)
  end

  def get_location_name(location, "zh-TW") do
    %{chinese_name: chinese_name} = Enum.find(@buoy_data, fn x -> x.name == location end)
    chinese_name
  end
end
