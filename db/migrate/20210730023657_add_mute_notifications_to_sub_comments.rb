class AddMuteNotificationsToSubComments < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_comments, :mute_notifications, :boolean, default: false
  end
end
