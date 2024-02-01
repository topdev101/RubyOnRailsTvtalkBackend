# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  title      :string
#  active     :boolean
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :show_categories
  has_many :shows, through: :show_categories

  scope :active, -> { where(active: true) }
end
