# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          not null
#  follower_id :integer          not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Relationship < ApplicationRecord
  belongs_to :followed_user, class_name: 'User', foreign_key: :followed_id, counter_cache: :followed_users_count, optional: true
  belongs_to :follower_user, class_name: 'User', foreign_key: :follower_id, counter_cache: :followers_count, optional: true
end
