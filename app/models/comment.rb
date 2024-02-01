# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  ai_prompt          :text
#  hashtag            :string
#  images             :text             default([]), is an Array
#  likes_count        :integer
#  mute_notifications :boolean          default(FALSE)
#  shares_count       :bigint           default(0)
#  status             :integer          default("active")
#  sub_comments_count :integer
#  text               :string
#  videos             :text             default([]), is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_show_tms_id :string
#  show_id            :bigint
#  story_id           :integer
#  user_id            :bigint           not null
#
# Indexes
#
#  index_comments_on_parent_show_tms_id  (parent_show_tms_id)
#  index_comments_on_show_id             (show_id)
#  index_comments_on_status              (status)
#  index_comments_on_story_id            (story_id)
#  index_comments_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  include Reportable
  include Notifiable
  enum status: %i[active inactive]

  belongs_to :user, counter_cache: true, optional: true
  belongs_to :show, counter_cache: true, optional: true
  belongs_to :story, counter_cache: true, optional: true
  has_many :likes, dependent: :destroy
  has_many :sub_comments, dependent: :destroy
  has_many :shares, as: :shareable
  validates :text, presence: true

  after_create :broadcast

  def show_title
    show&.title
  end

  def short_text
    text&.truncate(500)
  end

  def preview_image
    images&.first
  end

  def as_json(options = {})
    super(options).merge({ tmsId: show&.tmsId })
  end

  def subject
    if show_id.present?
      show
    elsif story_id.present?
      story
    end
  end

  def broadcast
    CommentsChannel.broadcast_to(subject, websocket_data)
  rescue StandardError => e
    puts "Error broadcasting comment: #{e.message}"
  end

  def websocket_data
    string = ApplicationController.render(
      partial: 'comments/comment.jbuilder',
      locals: { comment: self }
    )
    JSON.parse(string) if string.present?
  end
end
