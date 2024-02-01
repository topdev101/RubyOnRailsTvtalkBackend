# == Schema Information
#
# Table name: stories
#
#  id              :bigint           not null, primary key
#  comments_count  :integer
#  description     :text             not null
#  image_url       :string
#  likes_count     :bigint
#  published_at    :datetime
#  shares_count    :bigint           default(0)
#  source          :text
#  title           :string           not null
#  url             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  show_id         :integer
#  story_source_id :bigint
#
# Indexes
#
#  index_stories_on_show_id                 (show_id)
#  index_stories_on_story_source_id         (story_source_id)
#  index_stories_on_title_and_published_at  (title,published_at)
#  index_stories_on_url                     (url) UNIQUE
#
require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
