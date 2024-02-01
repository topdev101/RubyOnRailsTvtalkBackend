json.results(@top_commenters) do |top_commenter|
  json.score top_commenter.score
  json.user do
    json.extract! top_commenter.user, :id, :image, :username, :comments_count, :likes_count, :comments_count,
                  :followed_users_count, :followers_count, :city, :bio
  end
end
