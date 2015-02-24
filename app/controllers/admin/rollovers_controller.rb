class Admin::RolloversController < Admin::BaseController
  before_filter :authorize_admin
  before_filter :load_season

  def index
    @rollovers = Rollover.where(season:@season).order(confirmed_at: :desc, created_at: :desc)
  end

  def new_multiple
    @subscriptions = Subscription.where(season: @season).order(created_at: :desc)
  end

  def create_multiple
    target_season = Season.find_by_id params[:target_season_id]
    original_season = @season
    subscriptions = Subscription.where( id: params[:subscription_ids] )

    rollovers = subscriptions.map do |subscription|
      rollover = Rollover.new(season: target_season, subscription: subscription)
      rollover.skip_confirmation_notification!
      rollover
    end

    if rollovers.all?(&:save)
      rollovers.each(&:send_confirmation_instructions)
      redirect_to admin_season_rollovers_path(target_season)
    else
      redirect_to admin_season_subscriptions_path(original_season)
    end
  end
end
