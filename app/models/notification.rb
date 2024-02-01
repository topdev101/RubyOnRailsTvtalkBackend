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
class Notification < ApplicationRecord
  belongs_to :actor, class_name: 'User'
  belongs_to :owner, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  before_validation :assign_owner, on: :create

  scope :unread, -> { where(read_at: nil) }
  after_create :broadcast

  private

  def broadcast
    NotificationsChannel.broadcast_to(owner, websocket_data)
  rescue => e
    Rails.logger.error(e)
  ensure
    true
  end

  def assign_owner
    self.owner = notifiable&.user
  end

  def websocket_data
    string = ApplicationController.render(
      partial: 'notifications/notification.jbuilder',
      locals: { notification: self }
    )
    JSON.parse(string) if string.present?
  end
end
