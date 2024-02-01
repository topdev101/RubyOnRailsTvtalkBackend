require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @like = likes(:one)
    @relationship = relationships(:one)
    @relationship2 = relationships(:two)
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { email: 'new@example.com', password: '12345alsjdl', username: 'new_user', zipcode: @user.zipcode }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user.username), as: :json
    assert_response :success
    assert_equal %w(username image reactions_count favorites_count followers_count following_count), response.parsed_body.keys
  end

  test "should update user" do
    patch user_url(@user.username), params: { email: @user.email, password_digest: @user.password_digest, username: @user.username, zipcode: @user.zipcode }, as: :json, headers: auth_header(@user)
    assert_response 200
  end

  test "should update password when password_confirmation matches" do
    new_password = '1234abcd'
    assert_changes -> { @user.reload.password_digest } do
      patch user_url(@user.username), params: { password: new_password, password_confirmation: new_password }, as: :json, headers: auth_header(@user)
    end
    assert_response 200
  end

  test "should not update password when password_confirmation does not match" do
    new_password = '1234abcd'
    assert_no_changes -> { @user.reload.password_digest } do
      patch user_url(@user.username), params: { password: new_password, password_confirmation: '123' }, as: :json, headers: auth_header(@user)
    end
    assert_response 422
    assert_equal ["doesn't match Password"], response.parsed_body['password_confirmation']
  end

  test "should get top users" do
    skip 'mock top commenters'
    get top_users_url(), as: :json

    assert_response :success

    assert_equal %w(id text hashtag user_id created_at updated_at show_id images likes_count sub_comments_count videos shares_count story_id mute_notifications status parent_show_tms_id tmsId), response.parsed_body['results'].first['user'].keys
  end

  test "should get reactions" do
    get user_reactions_url(@user.username), as: :json

    assert_response :success
    assert_pagination

    assert_equal %w(id text hashtag user_id created_at updated_at show_id images likes_count sub_comments_count videos shares_count story_id mute_notifications status parent_show_tms_id tmsId), response.parsed_body['results'].first.keys
  end

  test "should get favorites" do
    get user_favorites_url(@user.username), as: :json

    assert_response :success
    assert_pagination

    assert_equal %w(id tmsId title seasonNum episodeNum shares_count likes_count comments_count stories_count activity_count popularity_score shortDescription seriesId rootId preferred_image_uri episodeTitle), response.parsed_body['results'].first.keys
  end

  test "should get followers" do
    pp user_followers_url(@user.username)
    get user_followers_url(@user.username), as: :json

    assert_response :success
    assert_pagination

    assert_equal %w(id username image bio), response.parsed_body['results'].first.keys
  end

  test "should get following" do
    get user_following_url(@user.username), as: :json

    assert_response :success
    assert_pagination

    assert_equal %w(id username image bio), response.parsed_body['results'].first.keys
  end
end
