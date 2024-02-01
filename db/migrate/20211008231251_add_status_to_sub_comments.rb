class AddStatusToSubComments < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_comments, :status, :integer, default: 0
    add_index :sub_comments, :status
  end
end
