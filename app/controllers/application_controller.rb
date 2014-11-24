class ApplicationController < ActionController::Base
  include Pundit
  before_action :load_cms_context

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  private
  def load_cms_context
      @cms_site = Cms::Site.first
  end

  def unauthorized
    flash[:error] = "You are not authorised to access that page."
    if current_user
      redirect_to root_path
    else
      namespace = self.class.name.deconstantize
      case namespace
      when "Admin" then redirect_to new_admin_session_path
      when "User" then redirect_to new_user_session_path
      else redirect_to root_path
      end
    end
  end
end
