class SessionsController < ApplicationController
  def create
    if Rails.application.secrets.admin_password && params[:password] == Rails.application.secrets.admin_password
      session[:password] = params[:password]
      flash[:notice] = "Logged in as Admin"
      redirect_to '/'
    else
      flash[:alert] = "Incorrect password entered"
      redirect_to '/login'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Logged out successfully"
    redirect_to '/'
  end
end