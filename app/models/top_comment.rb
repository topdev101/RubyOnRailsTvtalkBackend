# == Schema Information
#
# Table name: top_comments
#
#  id    :bigint
#  score :decimal(, )
#
class TopComment < ApplicationRecord
  belongs_to :comment, foreign_key: :id

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
