module ApplicationHelper
  def logged_in?
    session[:password] == ENV['ADMIN_PASSWORD']
  end
end
