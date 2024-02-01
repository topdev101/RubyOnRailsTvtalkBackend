# == Schema Information
#
# Table name: top_commenters
#
#  score   :decimal(, )
#  user_id :bigint
#
# Indexes
#
#  index_top_commenters_on_user_id  (user_id)
#
class TopCommenter < ApplicationRecord
  belongs_to :user

  def self.with_profiles(limit: 25)
    self.includes(:user).order(score: :desc).limit(limit)
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
