json.extract! sub_comment, :id, :text, :comment_id, :images, :videos, :created_at
json.likes_count sub_comment.likes_count || 0
json.sub_comments_count sub_comment.sub_comments_count || 0
json.shares_count sub_comment.shares_count || 0
json.image_count sub_comment.images&.count || 0
json.video_count sub_comment.videos&.count || 0
json.has_profanity ProfanityFilter::Base.profane?(sub_comment.text)
json.key "#{sub_comment.class.name.underscore}-#{sub_comment.id}"
json.subject_type sub_comment.subject.class.to_s.underscore
json.subject_title sub_comment.subject.class.to_s.underscore.titlecase
json.type 'sub_comment'
json.status sub_comment.status

json.user do
  json.id sub_comment&.user&.id
  json.username sub_comment&.user&.username
  json.image sub_comment&.user&.image
end

json.comment do
  json.partial! 'admin/comments/comment', comment: sub_comment.comment
end if sub_comment.comment.present?
