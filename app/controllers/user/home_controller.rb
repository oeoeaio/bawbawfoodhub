class User::HomeController < User::BaseController
  def index
    authorize_user :home
    @subscriptions = SubscriptionPolicy::Scope.new(current_user, Subscription).resolve
  end
end
