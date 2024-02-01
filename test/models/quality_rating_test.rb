# == Schema Information
#
# Table name: quality_ratings
#
#  id          :bigint           not null, primary key
#  ratingsBody :string
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  show_id     :bigint
#
# Indexes
#
#  index_quality_ratings_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
require 'test_helper'

class QualityRatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
