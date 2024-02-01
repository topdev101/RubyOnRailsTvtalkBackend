# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

Networks::LIST.each do |network|
  p "Creating #{network[:callSign]}"
  Network.find_or_initialize_by(station_id: network[:stationId]).update_attributes!({
    name: network[:callSign],
    display_name: network[:affiliateCallSign] || network[:callSign],
    streaming: false
  })
end
