class ApplicationController < ActionController::Base
  before_action :load_cms_context

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def load_cms_context
      @cms_site = Cms::Site.first
      @cms_layout = @cms_site.layouts.find_by_identifier!('default')
  end
end
