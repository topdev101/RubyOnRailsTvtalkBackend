json.partial! partial: 'shared/pagination', records: @sub_comments

json.results do
  json.partial! 'admin/sub_comments/sub_comment', collection: @sub_comments, as: :sub_comment
end
