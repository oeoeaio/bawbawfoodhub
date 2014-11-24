class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:index]
  before_filter :load_season

  def index
    @subscriptions = Subscription.where(season: @season)
  end

  private

  def load_season
    @season = Season.find_by_slug params[:slug]
  end
end
