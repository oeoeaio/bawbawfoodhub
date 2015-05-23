class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:seasons_index, :users_index]
  before_filter :load_season, only: [:seasons_index]
  before_filter :load_user, only: [:users_index]

  def seasons_index
    @subscriptions = Subscription.joins(:user).preload(:user).where(season: @season).order(created_at: :desc)
    render :index
  end

  def users_index
    @subscriptions = Subscription.joins(:season).preload(:season).where(user: @user).order(created_at: :desc)
    render :index
  end
end
