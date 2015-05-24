class Admin::BaseController < ApplicationController
  after_action :verify_authorized
  layout 'admin'

  def pundit_user
    # Send the currently logged in admin user to pundit for admin actions
    current_admin
  end

  private

  # Method to work out the action name for pundit to authorize for admin
  def authorize_admin(resource = controller_name.classify.constantize)
    authorize resource, "admin_#{action_name}?".to_sym
  end

  def load_season
    @season = Season.find_by_slug params[:season_id]
    if @season.nil?
      flash[:error] = "No season by that name exists"
      redirect_to admin_root_path
    end
  end

  def load_user
    @user = User.find_by_id params[:user_id]
    if @user.nil?
      flash[:error] = "Unable to find the specified user"
      redirect_to admin_root_path
    end
  end
end
