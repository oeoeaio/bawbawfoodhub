module CmsAuth
  include ApplicationHelper

  def authenticate
    unless admin_signed_in?
      redirect_to new_admin_session_path
    end
  end
end