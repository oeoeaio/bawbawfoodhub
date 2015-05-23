class Admin::UsersController < Admin::BaseController
  before_filter :authorize_admin, only: [:index]

  def index
    @users = User.order(surname: :asc)
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
    params.require(:user).permit(:given_name, :surname, :email, :phone)
  end
end
