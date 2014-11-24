class User::BaseController < ApplicationController
  after_action :verify_authorized

  private

  # Method to work out the action name for pundit to authorize for user
  def authorize_user(resource = controller_name.classify.constantize)
    authorize resource, "user_#{action_name}?".to_sym
  end
end