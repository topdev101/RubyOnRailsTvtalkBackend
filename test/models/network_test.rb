# == Schema Information
#
# Table name: networks
#
#  id           :bigint           not null, primary key
#  display_name :string
#  name         :string
#  streaming    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  station_id   :string
#
# Indexes
#
#  index_networks_on_name  (name) UNIQUE
#
require 'test_helper'

class NetworkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
