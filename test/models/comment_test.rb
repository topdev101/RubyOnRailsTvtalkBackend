# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  ai_prompt          :text
#  hashtag            :string
#  images             :text             default([]), is an Array
#  likes_count        :integer
#  mute_notifications :boolean          default(FALSE)
#  shares_count       :bigint           default(0)
#  status             :integer          default("active")
#  sub_comments_count :integer
#  text               :string
#  videos             :text             default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_show_tms_id :string
#  show_id            :bigint
#  story_id           :integer
#  user_id            :bigint           not null
#
# Indexes
#
#  index_comments_on_parent_show_tms_id  (parent_show_tms_id)
#  index_comments_on_show_id             (show_id)
#  index_comments_on_status              (status)
#  index_comments_on_story_id            (story_id)
#  index_comments_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
