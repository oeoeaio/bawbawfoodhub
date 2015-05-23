class Admin::SubscriptionsController < Admin::BaseController
  before_filter :authorize_admin, only: [:seasons_index, :users_index, :new, :create]
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

  def new
    @subscription = Subscription.new
    @subscription.season = Season.find_by_slug params[:season_id] if params[:season_id]
    @subscription.user = User.find_by_id params[:user_id] if params[:user_id]
    render :new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      flash[:success] = "Successfully created a new subscription"
      redirect_to admin_season_subscriptions_path(@subscription.season)
    else
      render :new
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:season_id, :user_id, :box_size, :skip_confirmation_notification)
  end
end
