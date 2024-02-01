class CreateShowtimeNetwork < ActiveRecord::Migration[6.0]
  def up
    network_data = {
      "stationId": "11115",
      "callSign":"SHOW",
      "videoQuality": {
        "signalType":
        "Digital",
        "videoType":"SDTV"
      },
      "channel":"545",
      "preferredImage":
      {
        "width":"360",
        "height":"270",
        "uri":"http://wewe.tmsimg.com/assets/s11115_ll_h15_ac.png",
        "category":"Logo",
        "primary":"true"
      }
    }

    network = Network.find_or_create_by(name: network_data[:callSign], display_name: network_data[:affiliateCallSign] || network_data[:callSign], station_id: network_data[:stationId])
  end
end
