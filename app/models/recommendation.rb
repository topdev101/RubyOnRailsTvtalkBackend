# == Schema Information
#
# Table name: recommendations
#
#  id         :bigint           not null, primary key
#  rootId     :string
#  title      :string
#  tmsId      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint
#
# Indexes
#
#  index_recommendations_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
class Recommendation < ApplicationRecord
  belongs_to :show
end
