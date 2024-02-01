class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    user = get_user(token: params[:token])
    stream_for(user) if user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
