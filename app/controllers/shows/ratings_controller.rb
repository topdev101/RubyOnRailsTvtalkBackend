class Shows::RatingsController < ApplicationController
  before_action :set_show
  before_action :authorize_request

  def show
    @rating = @current_user.rating_for(@show)
    render json: { rating: @rating }
  end

  def create
    if params[:rating].present?
      @show.rate(@current_user, params[:rating])
    else
      head(:not_acceptable) and return
    end
  end

  private

  def set_show
    @show = Show.find_or_import_by_tms_id(normalized_lookup_param[:tmsId])
  end

  # Lookup via ID or TMS ID
  def normalized_lookup_param
    if params[:tmsId].present?
      { tmsId: params[:tmsId] }
    elsif params[:tms_id].present?
      { tmsId: params[:tms_id] }
    elsif params[:show_id].present?
      { tmsId: params[:show_id] }
    end
  end
end
