class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:seasons_index]
  before_filter :load_season

  def seasons_index
    @subscriptions = Subscription.where(season: @season).order(created_at: :desc)
    render :index
  end
end
