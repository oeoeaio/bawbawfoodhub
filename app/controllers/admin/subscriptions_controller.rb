class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:index]
  before_filter :load_season

  def index
    @subscriptions = Subscription.where(season: @season).order(created_at: :desc)
  end

  private

  def load_season
    @season = Season.find_by_slug params[:season_id]
    if @season.nil?
      flash[:error] = "No season by that name exists"
      redirect_to admin_root_path
    end
  end
end
