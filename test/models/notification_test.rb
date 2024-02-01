# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  message         :string
#  notifiable_type :string           not null
#  read_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  actor_id        :bigint           not null
#  notifiable_id   :bigint           not null
#  owner_id        :bigint           not null
#
# Indexes
#
#  index_notifications_on_actor_id                           (actor_id)
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_owner_id                           (owner_id)
#  index_notifications_on_read_at                            (read_at)
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  setup do
    @actor = users(:one)
    @comment = comments(:one)
    @sub_comment = sub_comments(:one)
  end

  test "when creating a notification for liking a comment" do
    @comment.likes.create(user: @actor)
    notification = @comment.user.notifications.last

    assert_equal "Comment", notification.notifiable_type
    assert_equal @comment.id, notification.notifiable_id
    assert_equal @actor, notification.actor
    assert_equal @comment.user, notification.owner
    assert_equal "#{@actor.username} liked your comment", notification.message
  end

  test "when creating a notification for liking a sub_comment" do
    @sub_comment.likes.create(user: @actor)
    notification = @sub_comment.user.notifications.last

    assert_equal "SubComment", notification.notifiable_type
    assert_equal @sub_comment.id, notification.notifiable_id
    assert_equal @actor, notification.actor
    assert_equal @sub_comment.user, notification.owner
    assert_equal "#{@actor.username} liked your reply", notification.message
  end

  test "when creating a notification for replying to a comment" do
    @comment.sub_comments.create(user: @actor)
    notification = @comment.user.notifications.last

    assert_equal "Comment", notification.notifiable_type
    assert_equal @sub_comment.id, notification.notifiable_id
    assert_equal @actor, notification.actor
    assert_equal @sub_comment.user, notification.owner
    assert_equal "#{@actor.username} replied to your comment", notification.message
  end

  test "when creating a notification for replying to a sub_comment" do
    @sub_comment.sub_comments.create(user: @actor)
    notification = @sub_comment.user.notifications.last

    assert_equal "SubComment", notification.notifiable_type
    assert_equal @sub_comment.id, notification.notifiable_id
    assert_equal @actor, notification.actor
    assert_equal @sub_comment.user, notification.owner
    assert_equal "#{@actor.username} replied to your response", notification.message
  end
end
