# == Schema Information
#
# Table name: awards
#
#  id         :bigint           not null, primary key
#  awardCatId :string
#  awardId    :string
#  awardName  :string
#  category   :string
#  name       :string
#  personId   :string
#  won        :boolean
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint
#
# Indexes
#
#  index_awards_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
class Award < ApplicationRecord
  belongs_to :show, counter_cache: true
end
