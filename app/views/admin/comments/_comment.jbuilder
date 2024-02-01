json.extract! comment, :id, :text, :show_id, :story_id, :status, :mute_notifications, :images, :videos, :created_at
json.tms_id comment&.show&.tmsId
json.seriesId comment&.show&.seriesId
json.likes_count comment.likes_count || 0
json.sub_comments_count comment.sub_comments_count || 0
json.shares_count comment.shares_count || 0
json.image_count comment.images&.count || 0
json.video_count comment.videos&.count || 0
json.has_profanity ProfanityFilter::Base.profane?(comment.text)
json.key "#{comment.class.name.underscore}-#{comment.id}"
json.subject_type comment.subject.class.to_s.underscore
json.subject_title comment&.subject&.title
json.type 'comment'

json.user do
  json.id comment&.user&.id
  json.username comment&.user&.username
  json.image comment&.user&.image
end
