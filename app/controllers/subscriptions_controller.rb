class SubscriptionsController < ApplicationController
  before_filter :load_season
  before_filter :pack_days_remaining?, only: [:new, :create]
  before_filter :validate_token, only: [:new_from_token]

  def new
    @user = User.new
    @subscription = Subscription.new
  end

  def new_from_token
    @subscription = Subscription.new( box_size: @rollover.subscription.box_size )
    render :new
  end

  def create
    if params[:raw_token]
      create_from_token
    else
      if params[:subscription][:user_attributes]
        if User.exists? email: params[:subscription][:user_attributes][:email]
          @email = params[:subscription][:user_attributes][:email]
          flash.now[:error] = "The user '#{params[:subscription][:user_attributes][:email]}' already exists, to manage subscriptions for this user, please login (top right)."
          render :user_exists
        else
          create_for_new_user
        end
      else
        create_for_current_user
      end
    end
  end

  private

  def load_season
    @season = Season.find_by_slug params[:season_id]
    if @season.nil?
      flash[:error] = "No season by that name exists"
      redirect_to root_path
    end
  end

  def pack_days_remaining?
    if !@season.signups_open || !@season.next_pack_with_lead_time_from(Time.now)
      flash[:error] = "Signups for the #{@season.name} season have closed."
      redirect_to root_path
    end
  end

  def user_params
    params[:subscription].require(:user_attributes).permit(:given_name, :surname, :email, :phone, :password, :password_confirmation)
  end

  def new_user_subscription_params
    params.require(:subscription).permit(:box_size, user_attributes: [:given_name, :surname, :email, :phone, :password, :password_confirmation]).merge season: @season
  end

  def existing_user_subscription_params
    params.require(:subscription).permit(:box_size).merge season: @season
  end

  def create_for_new_user
    @subscription = Subscription.new new_user_subscription_params
    if @subscription.save
      render :success
    else
      @user = User.new user_params
      @user.valid? # Adds errors
      flash.now[:error] = "Oops! There were some problems with the details you entered!"
      render :new
    end
  end

  def create_for_current_user
    @subscription = Subscription.new existing_user_subscription_params.merge user: current_user
    if @subscription.save
      render :success
    else
      @user = current_user || User.new
      render :new
    end
  end

  def create_from_token
    @rollover = Rollover.confirm_by_token(params[:raw_token])

    if @rollover.persisted? # Found a valid rollover object
      @subscription = Subscription.new(
      user: @rollover.user,
      season: @rollover.season,
      box_size: params[:subscription][:box_size]
      )
      if @subscription && @subscription.save
        render :success
      else
        @rollover.reset_confirmation_token!(params[:raw_token])
        @raw_token = params[:raw_token]
        render :new
      end
    else
      render :new
    end
  end

  def validate_token
    # Returns false if params[:raw_token] is nil
    confirmation_token = Devise.token_generator.digest(Rollover, :confirmation_token, params[:raw_token])

    if confirmation_token && rollover = Rollover.find_by_confirmation_token(confirmation_token)
      @rollover = rollover
      @raw_token = params[:raw_token]
    else
      flash[:error] = "Invalid token"
      redirect_to new_season_subscription_path(@season)
    end
  end
end
