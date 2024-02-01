class Admin::UsersController < AdminController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:update, :destroy]

  def index
    @users = User.order(id: :desc).page(params[:page])
  end

  def bots
    @users = User.where(is_robot: true)
    @jwts = @users.find_each.with_object({}) do |user, map|
      map[user.id] = encode({ user_id: user.id, username: user.username })
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.is_robot = true

    if @user.save
      render 'admin/users/show'
    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # Lets an admin login as a user. Restricted to admin created accounts ("robots") only.
  def login
    @user = User.find(params[:id])
    return head(:unauthorized) unless @user.is_robot?

    token = encode({ user_id: params[:id] })
    redirect_url = "#{ENV['FRONT_END_URL']}/guide?token=#{token}"
    redirect_to redirect_url
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :name, :password, :password_confirmation, :email, :image)
  end
end
