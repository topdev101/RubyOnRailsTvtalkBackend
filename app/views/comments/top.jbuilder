json.results do
  json.array! @top_comments.each do |top_comment|
    json.partial! 'comments/comment', comment: top_comment.comment
    json.score top_comment.score
  end
end
