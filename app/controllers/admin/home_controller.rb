class Admin::HomeController < Admin::BaseController

  def index
    authorize_admin :home
  end

end
