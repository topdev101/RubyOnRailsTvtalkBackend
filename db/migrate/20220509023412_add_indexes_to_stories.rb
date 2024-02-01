class AddIndexesToStories < ActiveRecord::Migration[6.0]
  def change
    add_index :stories, [:title, :published_at]
  end
end
