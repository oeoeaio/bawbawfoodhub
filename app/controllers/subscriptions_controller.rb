class SubscriptionsController < ApplicationController
  before_action :load_season
  before_action :pack_days_remaining?, only: [:new, :create]
  before_action :verify_recaptcha_token, only: :create

  def new
    # render :closed
    @user = User.new
    @subscription = Subscription.new
    render :new
  end

  def create
    if params[:subscription][:user_attributes]
      if User.exists? email: params[:subscription][:user_attributes][:email]
        user = User.find_by_email(params[:subscription][:user_attributes][:email])
        if user.valid_password?(params[:subscription][:user_attributes][:password])
          sign_in(user)
          create_for_current_user
        else
          @subscription = Subscription.new existing_user_subscription_params.merge(user: user)
          if @subscription.valid? # Adds errors
            @user = user
            flash.now[:error] = "The password you entered was incorrect."
            render :user_exists
          else
            @user = User.new user_params
            render :new
          end
        end
      else
        create_for_new_user
      end
    else
      if current_user
        create_for_current_user
      else
        @subscription = Subscription.new existing_user_subscription_params
        @subscription.valid? # Adds errors
        @user = User.new
        @user.valid? # Adds errors
        render :new
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
    if !@season.signups_open || !@season.first_pack_day_with_lead_time_after(Time.now)
      flash[:error] = "Signups for the #{@season.name} season have closed."
      redirect_to root_path
    end
  end

  def user_params
    params[:subscription].require(:user_attributes).permit(:given_name, :surname, :email, :phone, :password, :password_confirmation)
  end

  def new_user_subscription_params
    params.require(:subscription).permit(:box_size, :delivery, :frequency, :street_address, :town, :postcode, user_attributes: [:given_name, :surname, :email, :phone, :password, :password_confirmation]).merge season: @season
  end

  def existing_user_subscription_params
    params.require(:subscription).permit(:box_size, :delivery, :frequency, :street_address, :town, :postcode).merge season: @season
  end

  def create_for_new_user
    @subscription = Subscription.new new_user_subscription_params
    if @subscription.save
      AddUserToMailchimpJob.perform_later(@subscription.user)
      render :success
    else
      @user = User.new user_params
      @user.valid? # Adds errors
      flash.now[:error] = "Oops! There were some problems with the details you entered!"
      render :new
    end
  end

  def create_for_current_user
    existing_subscriptions = current_user.subscriptions.where(season: @season).order(created_at: :asc)
    @subscription = Subscription.new existing_user_subscription_params.merge(user: current_user)
    if existing_subscriptions.empty? || params[:confirmed]
      if @subscription.save
        render :success
      else
        @user = current_user
        render :new
      end
    else
      if @subscription.valid?
        @existing_subscription = existing_subscriptions.last
        render :confirm
      else
        @user = current_user
        render :new
      end
    end
  end

  def verify_recaptcha_token
    response = HTTParty.post("https://www.google.com/recaptcha/api/siteverify",
      query: {
        secret: Rails.application.secrets.recaptcha_secret_key,
        response: params[:recaptcha_token]
      }
    )

    return if response["success"] && response["action"] == 'subscribe' && response["score"] > 0.5
    Rails.logger.info("reCAPTCHA failed for token: #{params[:recaptcha_token]}")
    Rails.logger.info(response.inspect)
    render :sorry
  end
end
