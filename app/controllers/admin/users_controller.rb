class Admin::UsersController < Admin::BaseController
  before_action :authorize_admin, only: [:index, :new, :create]

  def index
    @users = User.order(surname: :asc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "Created new user: #{@user.email}"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
    authorize_admin @user
  end

  def update
    @user = User.find params[:id]
    authorize_admin @user

    if @user.update_attributes(user_params)
      flash[:success] = "User updated successfully"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:given_name, :surname, :email, :phone, :skip_initialisation)
  end

  def new_user_params
    generated_password = Devise.friendly_token.first(10)
    password_hash = { password: generated_password, password_confirmation: generated_password}
    user_params.merge! password_hash
  end
end
