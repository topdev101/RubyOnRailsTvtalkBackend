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
class Like < ApplicationRecord
  belongs_to :user, counter_cache: true, optional: true
  belongs_to :comment, optional: true, counter_cache: true
  belongs_to :show, optional: true, counter_cache: true
  belongs_to :sub_comment, optional: true, counter_cache: true
  belongs_to :story, optional: true, counter_cache: true

  after_create :create_notification

  scope :for_shows, -> { where.not(show_id: nil) }

  private

  def create_notification
    if comment_id
      message = "#{user.username} liked your comment"
      comment.notifications.create(actor: user, message: message)
    elsif sub_comment_id
      message = "#{user.username} liked your reply"
      sub_comment.notifications.create(actor: user, message: message)
    end
  end
end
