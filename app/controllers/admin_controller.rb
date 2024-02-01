class AdminController < ActionController::Base
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # This is a temporary solution to password-protecting the admin section.
  http_basic_authenticate_with name: "tvchat", password: "tvmatcher", unless: -> { Rails.env.development? }
  layout 'admin'

  def index
  end

  def encode(payload, exp = 90.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
end
