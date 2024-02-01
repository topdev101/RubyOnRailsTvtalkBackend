module ApplicationCable
  class Channel < ActionCable::Channel::Base
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end
  
    def get_user(token:)
      decoded = decode(token)
      User.find(decoded[:user_id])
    end
  end
end
