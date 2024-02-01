json.partial! partial: 'shared/pagination', records: @comments

json.results do
  json.partial! 'admin/comments/comment', collection: @comments, as: :comment
end
