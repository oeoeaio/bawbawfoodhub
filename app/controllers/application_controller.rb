class ApplicationController < ActionController::Base
  include Pundit
  before_action :load_cms_context

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def load_cms_context
      @cms_site = Cms::Site.first
  end
end
