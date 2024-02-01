# == Schema Information
#
# Table name: keywords
#
#  id          :bigint           not null, primary key
#  Character   :string           default([]), is an Array
#  Mood        :string           default([]), is an Array
#  Setting     :string           default([]), is an Array
#  Subject     :string           default([]), is an Array
#  Theme       :string           default([]), is an Array
#  Time_Period :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  show_id     :bigint
#
# Indexes
#
#  index_keywords_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
