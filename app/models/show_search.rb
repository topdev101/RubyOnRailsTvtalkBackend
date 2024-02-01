# == Schema Information
#
# Table name: show_searches
#
#  id                  :bigint
#  cast                :json             is an Array
#  genres              :string           is an Array
#  lower_title         :text
#  popularity_score    :integer
#  preferred_image_uri :string
#  releaseYear         :integer
#  sort_score          :float
#  subType             :string
#  title               :string
#  tmsId               :string
#
class ShowSearch < ApplicationRecord
  scope :by_title, -> (query) { where('lower_title LIKE ?', "%#{query.downcase}%") }
  scope :ordered_by_match_and_popularity, -> (query) do
    order("
      case
      when lower_title LIKE '#{query.downcase}' then 5000 + sort_score
      when lower_title LIKE '#{query.downcase}%' then 20 + sort_score
      when lower_title LIKE '%#{query.downcase}%' then 5 + sort_score
      else 1 + sort_score
      end DESC")
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
