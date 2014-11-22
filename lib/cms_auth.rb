module CmsAuth
  include ApplicationHelper

  def authenticate
    unless logged_in?
      redirect_to new_session_path
    end
  end
end