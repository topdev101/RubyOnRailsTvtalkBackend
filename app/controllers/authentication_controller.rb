class AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :login_social, :login_apple, :apple_test]

  def login
    if login_params[:username]&.include?('@')
      @user = User.find_by(email: login_params[:username])
    else
      @user = User.find_by(username: login_params[:username])
    end

    if @user&.google_id.present?
      error_message = "It looks like you have already created a TV Talk account with Google. Please return to the login page and sign in with Google."
      render json: { error: error_message }, status: :unauthorized and return
    end

    if @user&.facebook_id.present?
      error_message = "It looks like you have already created a TV Talk account with Facebook. Please return to the login page and sign in with Facebook."
      render json: { error: error_message }, status: :unauthorized and return
    end


    if @user.present? && @user.authenticate(login_params[:password]) #authenticate method provided by Bcrypt and 'has_secure_password'
      token = encode(user_id: @user.id, username: @user.username)
      render json: { token: token , user: @user}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def login_social
    if params[:google_token]
      social_data = GoogleAuthVerification.verify(params[:google_token])
      google_id = social_data.dig('sub')

      if User.where(email: social_data['email']).where.not(facebook_id: nil).exists?
        error_message = "It looks like you have already created a TV Talk account with Facebook. Please return to the login page and sign in with Facebook."
        render json: { error: error_message }, status: :unauthorized and return
      end

      if User.where(email: social_data['email']).where(google_id: nil).exists?
        error_message = "It looks like you have already created a TV Talk account using your preferred email address and a unique password. Please return to the login page and log in with your preferred email and unique password. If you have forgotten your password, you can reset it at the login page."
        render json: { error: error_message }, status: :unauthorized and return
      end

      @user = User.find_or_initialize_by(google_id: google_id) unless google_id.blank?

      unless @user.persisted?
        @user.email = social_data.dig('email')
        @user.image = social_data.dig('picture')
        @user.username = User.get_unique_username(social_data.dig('email')&.split('@')&.first)
        @user.password = SecureRandom.alphanumeric(64) # random password
        @user.save
      end
    end

    if params[:facebook_token]
      social_data = HTTParty.get("https://graph.facebook.com/v8.0/#{params[:facebook_id]}?fields=email,name,picture&access_token=#{params[:facebook_token]}")

      if User.where(email: social_data['email']).where.not(google_id: nil).exists?
        error_message = "It looks like you have already created a TV Talk account with Google. Please return to the login page and sign in with Google."
        render json: { error: error_message }, status: :unauthorized and return
      end

      if User.where(email: social_data['email']).where(facebook_id: nil).exists?
        error_message = "It looks like you have already created a TV Talk account using your preferred email address and a unique password. Please return to the login page and log in with your preferred email and unique password. If you have forgotten your password, you can reset it at the login page."
        render json: { error: error_message }, status: :unauthorized and return
      end

      facebook_id = social_data.dig('id')
      @user = User.find_or_initialize_by(facebook_id: facebook_id) unless facebook_id.blank?

      unless @user.persisted?
        @user.email = social_data.dig('email')
        @user.image = social_data.dig('picture', 'data', 'url')
        @user.username = User.get_unique_username(social_data.dig('email')&.split('@')&.first)
        @user.password = SecureRandom.alphanumeric(64) # random password
        @user.save
      end
    end

    if @user && @user.persisted?
      token = encode(user_id: @user.id, username: @user.username)
      render json: { token: token , user: @user}, status: :ok
    else
      error_message = @user.errors.full_messages.to_sentence
      Rails.logger.warn "Social login/signup unsuccessful: #{error_message}"
      render json: { error: error_message }, status: :unauthorized
    end
  end

  def login_apple
    validator = AppleIdToken::Validator

    begin
      payload = validator.validate(token: params[:authorization].require(:id_token), aud: ENV['APPLE_KEY_ID'])
      user_id = payload['sub']
      email = payload['email']
    # rescue AppleIdToken::PublicKeysError => e
    #   Rails.logger.warn "Provided keys are invalid: #{e}"
    #   render json: { error: "There was an issue logging in" }, status: :unauthorized
    # rescue AppleIdToken::ValidationError => e
    #   Rails.logger.warn "Cannot validate: #{e}"
    #   render json: { error: "There was an issue logging in" }, status: :unauthorized
    end

    @user = User.find_or_initialize_by(apple_id: payload['sub'])

    if !@user.persisted?
      if params[:user].present?
        name = [params.dig(:user, :firstName), params.dig(:user, :lastName)].join(' ')
        @user.name = email if name.present?
      end
      @user.email = email if @user.email.blank?
      @user.username = @user.email&.split('@')&.first if @user.username.blank?
      @user.password = SecureRandom.alphanumeric(64) # random password
      @user.save
    end

    if @user && @user.persisted?
      token = encode(user_id: @user.id, username: @user.username)
      render json: { token: token , user: @user}, status: :ok
    else
      error_message = @user.errors.full_messages.to_sentence
      Rails.logger.warn "Social login/signup unsuccessful: #{error_message}"
      render json: { error: error_message }, status: :unauthorized
    end
  end

  def verify
    render json: @current_user
  end

  def apple_test
    # temporary to test end-to-end apple auth
  end

  private
  def login_params
    params.permit(:username, :password)
  end
end
