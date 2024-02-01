class SubCommentsController < ApplicationController
  before_action :get_current_user, only: [:index]
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_sub_comment, only: [:update, :destroy]

  # GET /sub_comments
  def index
    if params[:comment_id]
      @sub_comments = SubComment.includes(:user).where(comment_id: params[:comment_id]).page(params[:page])
    elsif params[:sub_comment_id]
      @sub_comments = SubComment.includes(:user).where(sub_comment_id: params[:sub_comment_id]).page(params[:page])
    else
      head(:bad_request) and return
    end
  end

  # GET /sub_comments/1
  def show
    @sub_comment = SubComment.includes(:user).find(params[:id])
    render json: @sub_comment
  end

  # POST /sub_comments
  def create
    @sub_comment = @current_user.sub_comments.new(sub_comment_params)
    if @sub_comment.save
      render json: @sub_comment, status: :created, location: @sub_comment
    else
      render json: @sub_comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sub_comments/1
  def update
    if @sub_comment.update(sub_comment_params)
      render json: @sub_comment
    else
      render json: @sub_comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sub_comments/1
  def destroy
    @sub_comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_comment
      head(:unauthorized) and return if @current_user.blank?
      @sub_comment = @current_user.sub_comments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      head(:not_found)
    end

    # Only allow a trusted parameter "allow list" through.
    def sub_comment_params
      params.require(:sub_comment).permit(:text, :comment_id, :sub_comment_id, :mute_notifications, images: [], videos: [])
    end
end
