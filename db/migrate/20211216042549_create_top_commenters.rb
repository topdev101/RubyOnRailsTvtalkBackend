class CreateTopCommenters < ActiveRecord::Migration[6.0]
  def change
    create_view :top_commenters, materialized: true
    add_index :top_commenters, :user_id, order: { score: :desc }
  end
end
