json.extract! @user, :id, :username, :image, :created_at, :is_robot

json.reactions_count @user.comments_count
json.favorites_count @user.likes_count
json.followers_count @user.followers_count
json.following_count @user.followed_users_count