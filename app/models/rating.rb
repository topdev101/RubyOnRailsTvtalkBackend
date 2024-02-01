# == Schema Information
#
# Table name: ratings
#
#  id         :bigint           not null, primary key
#  body       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint
#
# Indexes
#
#  index_ratings_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
class Rating < ApplicationRecord
  belongs_to :show
end