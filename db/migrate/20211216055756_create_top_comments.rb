class CreateTopComments < ActiveRecord::Migration[6.0]
  def change
    create_view :top_comments, materialized: true
  end
end
