require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'test@example.com',
      username: 'example', password: 'password')
  end

  test 'user can login with username' do
    params = {
      username: @user.username,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json
    assert :success
    assert json_response.has_key?('token')
    refute json_response.has_key?('error')
  end

  test 'user can login with email' do
    params = {
      username: @user.email,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json

    assert :success
    assert json_response.has_key?('token')
    refute json_response.has_key?('error')
  end

  test 'user cannot login with invalid password' do
    params = {
      username: @user.username,
      password: 'invalid_password'
    }
    post auth_login_path, params: params, as: :json

    refute json_response.has_key?('token')
    assert json_response.has_key?('error')
    assert :unauthorized
  end

  test 'a user can sign up via Google' do
    social_params = {
      sub: '123',
      email: 'auth@example.com'
    }.as_json
    GoogleAuthVerification.stubs(:verify).returns(social_params)

    assert_difference -> { User.count }, 1 do
      post auth_login_social_url, params: { google_token: '123' }
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert_equal 'auth', response.parsed_body['user']['username']
    assert_equal 'auth@example.com', response.parsed_body['user']['email']
    refute response.parsed_body.has_key?('error')
  end

  test 'a user can log in via Google' do
    @user.update(google_id: '123', email: 'auth@example.com')
    social_params = {
      sub: '123',
      email: 'auth@example.com'
    }.as_json
    GoogleAuthVerification.stubs(:verify).returns(social_params)

    assert_no_difference -> { User.count } do
      post auth_login_social_url, params: { google_token: '123' }
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert_equal 'example', response.parsed_body['user']['username']
    assert_equal 'auth@example.com', response.parsed_body['user']['email']
    refute response.parsed_body.has_key?('error')
  end


  test 'a user can sign up via Facebook' do
    facebook_id = '123'
    facebook_token = 'fbtoken'
    social_data = {
      id: facebook_id,
      email: 'facebook_auth@example.com',
    }.as_json

    facebook_url = "https://graph.facebook.com/v8.0/#{facebook_id}?fields=email,name,picture&access_token=#{facebook_token}"
    HTTParty.stubs(:get).with(facebook_url).returns(social_data)

    assert_difference -> { User.count }, 1 do
      post auth_login_social_url, params: { facebook_id: facebook_id, facebook_token: facebook_token }
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert_equal 'facebook_auth', response.parsed_body['user']['username']
    assert_equal 'facebook_auth@example.com', response.parsed_body['user']['email']
    refute response.parsed_body.has_key?('error')
  end

  test 'a user can log in via Facebook' do
    facebook_id = '123'
    facebook_token = 'fbtoken'
    social_data = {
      id: facebook_id,
      email: 'example@example1.com',
    }.as_json

    @user.update(facebook_id: facebook_id, email: 'auth@example.com')

    facebook_url = "https://graph.facebook.com/v8.0/#{facebook_id}?fields=email,name,picture&access_token=#{facebook_token}"
    HTTParty.stubs(:get).with(facebook_url).returns(social_data)

    assert_no_difference -> { User.count } do
      post auth_login_social_url, params: { facebook_id: facebook_id, facebook_token: facebook_token }
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert_equal 'example', response.parsed_body['user']['username']
    assert_equal 'auth@example.com', response.parsed_body['user']['email']
    refute response.parsed_body.has_key?('error')
  end

  test 'a user can sign up via Apple' do
    id_token = "eyJraWQiOiJZdXlYb1kiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiYXBwLnR2dGFsay5zaWduaW4iLCJleHAiOjE2MzA1NTc1NTQsImlhdCI6MTYzMDQ3MTE1NCwic3ViIjoiMDAxNzgzLjdiZWQxYmZmNzNjNzRjN2RhZTE3NjcwOWVlYzNlNjlhLjAzNTgiLCJjX2hhc2giOiJOWGtFRXpqRUxvbXJuNk4xaEhBTTdnIiwiZW1haWwiOiJnZ2huNHhrODc4QHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjMwNDcxMTU0LCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.Vc8o7exgUwIyvToZsWLo_lEuJO-fg9f_6clC8IKrTBJGBbRYdIniFL9gcmMW5BtKHj8x1pOH1mJIhch9th_SEN3-NJSXjELQOqpz_22dTDjJXRHTzbPaBxfcSQ1UcZJExoC28yMTwjtxe3VtsAaVBQF_BCsB8wI8uWd-u4COR1UnDFARCBqIlVPFNmwEYgU45D8Mww_qdAe3JZrnaOIlOHct9RLJZzAZknA3IUm2-2JyYx3G_Qs2VzcXY19RBx2cSC9u-TxqxT7pYLATC09oHMsDSgCZlUgKvtQ62oxpnVFFM-_wRh-ABBBSUhXibqnz2YYIdDmt8brooHyjyAgV5A"
    apple_user_data = {
      name: {
        firstName: "Dolph",
        lastName: "Lundgren"
      },
      email: 'test-apple@example.com'
    }
    
    VCR.use_cassette('apple_auth_sign_up') do
      assert_difference -> { User.count }, 1 do
        post auth_apple_url, params: { 
          authorization: {
            id_token: id_token
          },
          user: apple_user_data
        }
      end
    end

    assert_response :success
    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert_equal 'test-apple', response.parsed_body['user']['username']
    assert_equal 'test-apple@example.com', response.parsed_body['user']['email']
    assert_equal '001783.7bed1bff73c74c7dae176709eec3e69a.0358', response.parsed_body['user']['apple_id']
    refute response.parsed_body.has_key?('error')
  end

  test 'a user can sign in via Apple' do
    id_token = "eyJraWQiOiI4NkQ4OEtmIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiYXBwLnR2dGFsay5zaWduaW4iLCJleHAiOjE2MzA1NTEwOTAsImlhdCI6MTYzMDQ2NDY5MCwic3ViIjoiMDAxNzgzLjdiZWQxYmZmNzNjNzRjN2RhZTE3NjcwOWVlYzNlNjlhLjAzNTgiLCJjX2hhc2giOiJrRVV0Y1pWeVdVUDE4TUdOdU96VUNBIiwiZW1haWwiOiJnZ2huNHhrODc4QHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjMwNDY0NjkwLCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.gGBncFALuHMJEJP2O_yI3ceFi-P5xfLE1I0eGzKdVbl07thhAHqkiAaIsjYX2SS6qdigO36Ih1JmYNf9OhGe_LLCsuMYPaNK4gS2eEH1N3UGfWPM9vMiS1CP1ePDZEwFk_AHQdS3lMwITEUhqmm84xc1_pi4VtaIDuk-uM00mTgRyDgwE-fjFQgxEzc2rdSBfpaWmln07qQOffgH6XpbB7xQJk14-0gJf2PI6bxpAE4uA6uaT6o1mQ9v1-svtdokS5JPjyO18pFIzml09KVYjbV0VbbXFFwtU7cqQVru-R10HbSKO2OMHGC2BHvWPbbe0KeKDfOD6BYnzBjyTfX_0w"
    social_data = {
      "iss"=>"https://appleid.apple.com",
      "aud"=>"app.tvtalk.signin",
      "exp"=>1630551090,
      "iat"=>1630464690,
      "sub"=>"001783.7bed1bff73c74c7dae176709eec3e69a.0358",
      "c_hash"=>"kEUtcZVyWUP18MGNuOzUCA",
      "email"=>"gghn4xk878@privaterelay.appleid.com",
      "email_verified"=>"true",
      "is_private_email"=>"true",
      "auth_time"=>1630464690,
      "nonce_supported"=>true
    }

    @user.update(apple_id: social_data["sub"], email: social_data["email"])

    VCR.use_cassette('apple_sign_in') do
      assert_no_difference -> { User.count } do
        assert_no_changes -> { @user.email } do
          assert_no_changes -> { @user.username } do
            post auth_apple_url, params: {
              authorization: {
                id_token: id_token
              }
            }
          end
        end
      end
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert response.parsed_body['user'].has_key?('username')
    assert response.parsed_body['user'].has_key?('email')
    refute response.parsed_body.has_key?('error')
  end

  test 'when a user has a Facebook account but logs in with a Google account' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456', facebook_id: 123)
    social_params = {
      sub: '123',
      email: user.email
    }.as_json

    GoogleAuthVerification.stubs(:verify).returns(social_params)
    post auth_login_social_url, params: { google_token: '123' }

    assert_response :unauthorized
    assert_equal 'It looks like you have already created a TV Talk account with Facebook. Please return to the login page and sign in with Facebook.', response.parsed_body['error']
  end

  test 'when a user has a Google account but logs in with a Facebook account' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456', google_id: 123)
    facebook_token = 'fbtoken'
    social_data = {
      id: '123',
      email: user.email,
    }.as_json

    facebook_url = "https://graph.facebook.com/v8.0/#{user.facebook_id}?fields=email,name,picture&access_token=#{facebook_token}"
    HTTParty.stubs(:get).with(facebook_url).returns(social_data)

    post auth_login_social_url, params: { facebook_id: user.facebook_id, facebook_token: facebook_token }

    assert_response :unauthorized
    assert_equal 'It looks like you have already created a TV Talk account with Google. Please return to the login page and sign in with Google.', response.parsed_body['error']
  end

  test 'when a user has a traditional account but logs in with a Facebook account' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456')
    social_params = {
      sub: '123',
      email: user.email
    }.as_json

    GoogleAuthVerification.stubs(:verify).returns(social_params)
    post auth_login_social_url, params: { google_token: '123' }

    assert_response :unauthorized
    assert_equal 'It looks like you have already created a TV Talk account using your preferred email address and a unique password. Please return to the login page and log in with your preferred email and unique password. If you have forgotten your password, you can reset it at the login page.', response.parsed_body['error']
  end

  test 'when a user has a traditional account but logs in with a Google account' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456')
    social_params = {
      sub: '123',
      email: user.email
    }.as_json

    GoogleAuthVerification.stubs(:verify).returns(social_params)
    post auth_login_social_url, params: { google_token: '123' }

    assert_equal 'It looks like you have already created a TV Talk account using your preferred email address and a unique password. Please return to the login page and log in with your preferred email and unique password. If you have forgotten your password, you can reset it at the login page.', response.parsed_body['error']
  end

  test 'when a user has a Google account but logs in with an email and password' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456', google_id: 123)
    params = {
      username: user.email,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json

    assert_equal 'It looks like you have already created a TV Talk account with Google. Please return to the login page and sign in with Google.', response.parsed_body['error']
  end

  test 'when a user has a Facebook account but logs in with an email and password' do
    user = User.create(email: 'auth@example.com', username: 'auth', password: '123456', facebook_id: 123)
    params = {
      username: user.email,
      password: 'password'
    }
    post auth_login_path, params: params, as: :json

    assert_equal 'It looks like you have already created a TV Talk account with Facebook. Please return to the login page and sign in with Facebook.', response.parsed_body['error']
  end

  test 'when a user signs up via social login but their derived username exists' do
    social_params = {
      sub: '123',
      email: "#{@user.username}@social.com"
    }.as_json
    GoogleAuthVerification.stubs(:verify).returns(social_params)

    assert_difference -> { User.count }, 1 do
      post auth_login_social_url, params: { google_token: '123' }
    end

    assert response.parsed_body.has_key?('token')
    assert response.parsed_body['user'].has_key?('id')
    assert response.parsed_body['user'].has_key?('username')
    assert_not_equal @user.username, response.parsed_body['user']['username']
    assert_equal "#{@user.username}@social.com", response.parsed_body['user']['email']
    refute response.parsed_body.has_key?('error')
  end
end
