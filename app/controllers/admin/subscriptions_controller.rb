class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:index]
  before_filter :load_season

  def index
    @subscriptions = Subscription.where(season: @season).order(created_at: :desc)
  end
end
