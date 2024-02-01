class AddMuteNotificationsToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :mute_notifications, :boolean, default: false
  end
end
