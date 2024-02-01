# == Schema Information
#
# Table name: shares
#
#  id             :bigint           not null, primary key
#  shareable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shareable_id   :integer          not null
#  user_id        :bigint
#
# Indexes
#
#  index_shares_on_shareable_id_and_shareable_type  (shareable_id,shareable_type)
#  index_shares_on_user_id                          (user_id)
#
class Share < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shareable, polymorphic: true, counter_cache: true
end
