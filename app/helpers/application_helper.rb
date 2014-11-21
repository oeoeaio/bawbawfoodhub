module ApplicationHelper
  def logged_in?
    Rails.application.secrets.admin_password && session[:password] == Rails.application.secrets.admin_password
  end
end
