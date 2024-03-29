# == Schema Information
#
# Table name: story_sources
#
#  id              :bigint           not null, primary key
#  domain          :string           not null
#  enabled         :boolean          default(TRUE)
#  iframe_enabled  :boolean          default(FALSE)
#  image_url       :string
#  last_scraped_at :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_story_sources_on_domain   (domain) UNIQUE
#  index_story_sources_on_enabled  (enabled)
#
require 'test_helper'

class StorySourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
