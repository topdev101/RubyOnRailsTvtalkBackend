class Admin::SubCommentsController < AdminController
  skip_before_action :verify_authenticity_token
  before_action :set_sub_comment, only: [:update, :destroy]

  def index
    @sub_comments = SubComment.includes(:user).order(id: :desc).page(params[:page])
    respond_to do |format|
      format.html
      format.json
    end
  end

  # PATCH/PUT /sub_comments/1
  # PATCH/PUT /sub_comments/1.json
  def update
    @sub_comment.assign_attributes(sub_comment_params)

    if @sub_comment.save
    else
      render json: @sub_comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sub_comments/1
  # DELETE /sub_comments/1.json
  def destroy
    @sub_comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_comment
      @sub_comment = SubComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sub_comment_params
      params.require(:sub_comment).permit(:status)
    end
end
