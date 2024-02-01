json.partial! partial: 'shared/pagination', records: @users

json.results(@users) do |user|
  json.extract! user, :id, :username, :email, :zipcode, :created_at, 
    :image, :bio, :city, :phone_number, :streaming_service, :likes_count, :comments_count, :login_type, :is_robot
end