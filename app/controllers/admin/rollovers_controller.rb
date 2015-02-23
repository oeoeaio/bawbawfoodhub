class Admin::RolloversController < Admin::BaseController
  before_filter :authorize_admin
  before_filter :load_season

  def index
  end

  def create_multiple
    season = Season.find_by_slug params[:season_id]
    original_season = Season.find_by_slug params[:original_season_id]
    subscriptions = Subscription.where( id: params[:subscription_ids].split(",") )

    rollovers = subscriptions.map do |subscription|
      rollover = Rollover.new(season: season, subscription: subscription)
      rollover.skip_confirmation_notification!
      rollover
    end

    if rollovers.all?(&:save)
      rollovers.each(&:send_confirmation_instructions)
      redirect_to admin_season_rollovers_path(season)
    else
      redirect_to admin_season_subscriptions_path(original_season)
    end
  end
end
