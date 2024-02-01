# == Schema Information
#
# Table name: show_categories
#
#  id          :bigint           not null, primary key
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  show_id     :bigint           not null
#
# Indexes
#
#  index_show_categories_on_category_id              (category_id)
#  index_show_categories_on_show_id                  (show_id)
#  index_show_categories_on_show_id_and_category_id  (show_id,category_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (show_id => shows.id)
#
class ShowCategory < ApplicationRecord
  belongs_to :show
  belongs_to :category
  default_scope { order(position: :asc) }
end
