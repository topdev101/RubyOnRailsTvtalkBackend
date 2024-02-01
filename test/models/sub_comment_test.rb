# == Schema Information
#
# Table name: sub_comments
#
#  id                 :bigint           not null, primary key
#  hashtag            :string
#  images             :text             default([]), is an Array
#  likes_count        :integer          default(0)
#  mute_notifications :boolean          default(FALSE)
#  shares_count       :bigint           default(0)
#  status             :integer          default("active")
#  sub_comments_count :integer          default(0)
#  text               :string
#  videos             :text             default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  comment_id         :bigint
#  sub_comment_id     :integer
#  user_id            :bigint           not null
#
# Indexes
#
#  index_sub_comments_on_comment_id      (comment_id)
#  index_sub_comments_on_status          (status)
#  index_sub_comments_on_sub_comment_id  (sub_comment_id)
#  index_sub_comments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class SubCommentTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @comment = comments(:one)
    @sub_comment = sub_comments(:one)
  end

  test "creates a notification when comment is not muted" do
    @comment.update_attributes(mute_notifications: false)
    sub_comment = SubComment.new(comment_id: @comment.id, text: 'A sub comment', user: @user)
    assert_difference -> { @comment.notifications.count }, 1 do
      assert sub_comment.save
    end
  end

  test "creates a notification when sub comment is not muted" do
    @sub_comment.update_attributes(mute_notifications: false)
    sub_comment = SubComment.new(sub_comment_id: @sub_comment.id, text: 'A sub comment', user: @user)
    assert_difference -> { @sub_comment.notifications.count }, 1 do
      assert sub_comment.save
    end
  end

  test "does not create a notification when comment is muted" do
    @comment.update_attributes(mute_notifications: true)
    sub_comment = SubComment.new(comment_id: @comment.id, text: 'A sub comment', user: @user)
    assert_no_difference -> { @comment.notifications.count } do
      assert sub_comment.save
    end
  end

  test "does not creates a notification when sub comment is muted" do
    @sub_comment.update_attributes(mute_notifications: true)
    sub_comment = SubComment.new(sub_comment_id: @sub_comment.id, text: 'A sub comment', user: @user)
    assert_no_difference -> { @sub_comment.notifications.count } do
      assert sub_comment.save
    end
  end
end
