class UpdateShowSearchesToVersion4 < ActiveRecord::Migration[6.0]
  def change
    update_view :show_searches, version: 4, revert_to_version: 3, materialized: true
  end
end
