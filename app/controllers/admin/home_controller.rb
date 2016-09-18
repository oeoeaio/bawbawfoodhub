class Admin::HomeController < Admin::BaseController

  def index
    authorize_admin :home
    @subscriptions = Subscription.where('created_at > ?', 1.month.ago).order('created_at DESC')
  end

end
