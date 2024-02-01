# == Schema Information
#
# Table name: preferred_images
#
#  id         :bigint           not null, primary key
#  category   :string
#  height     :string
#  primary    :string
#  uri        :text
#  width      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint
#
# Indexes
#
#  index_preferred_images_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
class PreferredImage < ApplicationRecord
  belongs_to :show
end
