# == Schema Information
#
# Table name: casts
#
#  id            :bigint           not null, primary key
#  billingOrder  :string
#  characterName :string
#  name          :string
#  nameId        :string
#  personId      :string
#  role          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  show_id       :bigint
#
# Indexes
#
#  index_casts_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
require 'test_helper'

class CastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
