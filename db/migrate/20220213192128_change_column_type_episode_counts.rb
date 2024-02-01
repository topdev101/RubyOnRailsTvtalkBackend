class ChangeColumnTypeEpisodeCounts < ActiveRecord::Migration[6.0]
  def change
    change_column :shows, :episodes_count, :int
  end
end
