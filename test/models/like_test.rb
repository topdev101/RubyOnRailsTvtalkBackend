# == Schema Information
#
# Table name: likes
#
#  id             :bigint           not null, primary key
#  like           :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  comment_id     :bigint
#  show_id        :bigint
#  story_id       :bigint
#  sub_comment_id :bigint
#  user_id        :bigint           not null
#
# Indexes
#
#  index_likes_on_comment_id      (comment_id)
#  index_likes_on_show_id         (show_id)
#  index_likes_on_sub_comment_id  (sub_comment_id)
#  index_likes_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (show_id => shows.id)
#  fk_rails_...  (sub_comment_id => sub_comments.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
