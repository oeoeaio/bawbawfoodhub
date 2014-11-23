class Admin::BaseController < ApplicationController
  after_action :verify_authorized

  def pundit_user
    # Send the currently logged in admin user to pundit for admin actions
    current_admin
  end

  private

  # Method to work out the action name for pundit to authorize for admin
  def authorize_admin(resource = controller_name.classify.constantize)
    authorize resource, "admin_#{action_name}?".to_sym
  end
end