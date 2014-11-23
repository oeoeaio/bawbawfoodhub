class Admin::HomeController < Admin::BaseController

  def index
    authorize :home, :admin_index?
  end

end
