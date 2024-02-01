class CommentsChannel < ApplicationCable::Channel
  def subscribed
    subject = get_subject
    stream_for(subject) if subject.present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def get_subject
    if normalized_tms_id_param.present?
      Show.find_by(tmsId: normalized_tms_id_param)
    elsif params[:story_id].present?
      Story.find(params[:story_id])
    elsif params[:comment_id].present?
      Comment.find(params[:comment_id])
    elsif params[:sub_comment_id].present?
      SubComment.find(params[:sub_comment_id])
    elsif params[:username].present?
      User.find_by(username: params[:username])
    end
  end

  def normalized_tms_id_param
    params[:tms_id] || params[:tmsId]
  end
end
