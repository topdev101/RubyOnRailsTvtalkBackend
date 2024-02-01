class AddStatusToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :status, :integer, default: 0
    add_index :comments, :status
  end
end
