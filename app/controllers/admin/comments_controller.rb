class Admin::CommentsController < AdminController
  skip_before_action :verify_authenticity_token
  before_action :set_comment, only: [:update, :destroy]

  def index
    @comments = Comment.includes(:user, :show).order(id: :desc).page(params[:page])
    respond_to do |format|
      format.html
      format.json
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment.assign_attributes(comment_params)

    if @comment.save
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:status)
    end
end
