class AddBotProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bot_profile, :text
  end
end
