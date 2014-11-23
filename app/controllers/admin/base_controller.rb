class Admin::BaseController < ApplicationController
  after_action :verify_authorized

  def pundit_user
    # Send the currently logged in admin user to pundit for admin actions
    current_admin
  end
end