# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  bio                             :text
#  birth_date                      :string
#  bot_profile                     :text
#  cable_provider                  :string
#  city                            :string
#  comments_count                  :integer
#  email                           :string
#  followed_users_count            :integer
#  followers_count                 :integer
#  gender                          :string
#  image                           :text
#  is_robot                        :boolean          default(FALSE)
#  likes_count                     :integer
#  name                            :string
#  password_digest                 :string
#  password_reset_token            :string
#  password_reset_token_expiration :datetime
#  phone_number                    :string
#  streaming_service               :string
#  username                        :string
#  zipcode                         :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  apple_id                        :string
#  facebook_id                     :string
#  google_id                       :string
#
# Indexes
#
#  index_users_on_apple_id              (apple_id) UNIQUE
#  index_users_on_facebook_id           (facebook_id) UNIQUE
#  index_users_on_google_id             (google_id) UNIQUE
#  index_users_on_password_reset_token  (password_reset_token)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test '.generate_reset_password_token generates token and expiration' do
    UserMailer.any_instance.expects(:reset_password).once
    assert_nil @user.password_reset_token
    assert_nil @user.password_reset_token_expiration

    @user.generate_reset_password_token

    assert @user.password_reset_token
    assert @user.password_reset_token_expiration
    assert_equal @user.password_reset_token_expiration.to_date, 3.days.from_now.to_date
  end

  test '#reset_password with invalid token returns not found error' do
    UserMailer.any_instance.expects(:reset_password).never

    assert_raises ActiveRecord::RecordNotFound do
      User.reset_password('123', '123', '123')
    end
  end

  test '#reset_password with expired valid token returns not found error' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    @user.generate_reset_password_token
    @user.password_reset_token_expiration = 1.day.ago
    @user.save

    assert_raises ActiveRecord::RecordNotFound do
      User.reset_password(@user.password_reset_token, '123', '123')
    end
  end

  test '#reset_password with mismatched passwords raises error' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    new_password = SecureRandom.alphanumeric
    @user.generate_reset_password_token
    @user.save

    assert_raises ActiveRecord::RecordInvalid do
      User.reset_password(@user.password_reset_token, new_password, '123')
    end
  end

  test '#reset_password with valid token resets password and clears token' do
    UserMailer.any_instance.expects(:reset_password).once.returns(true)
    new_password = SecureRandom.alphanumeric
    @user.generate_reset_password_token
    @user.save

    User.reset_password(@user.password_reset_token, new_password, new_password)

    @user.reload
    refute @user.password_reset_token
    refute @user.password_reset_token_expiration
  end

  test 'can not create a user if the password is less than 6 characters' do
    user = User.new(email: 'sample@example.com', username: 'example', password: '12345')
    refute user.valid?
    refute user.save
    assert_equal 'Password should have 6 or more characters', user.errors[:password].to_sentence
  end

  test 'can create a user if the password is 6 characters' do
    user = User.new(email: 'sample@example.com', username: 'example', password: '123456')
    assert user.valid?
    assert user.save
    refute user.errors[:password].present?
  end

  test 'can not create a user if the username is taken' do
    user = User.new(email: 'sample@example.com', username: @user.username, password: '123456')
    refute user.valid?
    assert user.errors[:username].present?
  end

  test 'can not create a user if the email is taken' do
    user = User.new(email: @user.email, username: 'username1', password: '123456')
    refute user.valid?
    assert user.errors[:email].present?
  end

  test 'can not create a user if the facebook_id is taken' do
    @user.update(facebook_id: 123)
    user = User.new(email: @user.email, username: 'username1', password: '123456', facebook_id: 123)
    refute user.valid?
    assert user.errors[:facebook_id].present?
  end

  test 'can not create a user if the google_id is taken' do
    @user.update(google_id: 123)
    user = User.new(email: @user.email, username: 'username1', password: '123456', google_id: 123)
    refute user.valid?
    assert user.errors[:google_id].present?
  end

  test 'emails have case insensitive validation' do
    user = User.new(email: @user.email.upcase, username: 'username1', password: '123456', google_id: 123)
    refute user.save
    assert user.errors[:email].present?
  end

  test 'usernames have case insensitive validation' do
    user = User.new(email: 'new@example.net', username: @user.username.upcase, password: '123456', google_id: 123)
    refute user.save
    assert user.errors[:username].present?
  end

  test '.get_unique_username' do
    string = 'user'
    User.create(username: string, password: '123456', email: 'test@test.com')

    unique_username = User.get_unique_username(string)
    assert unique_username.present?
    assert_not_equal string, unique_username
  end
end
