class SubscriptionsController < ApplicationController
  def new
    @user = User.new
    @subscription = Subscription.new
  end

  def create
    if params[:subscription][:user_attributes]
      if User.exists? email: params[:subscription][:user_attributes][:email]
        flash[:error] = "The user '#{params[:subscription][:user_attributes][:email]}' already exists, to manage subscriptions for this user, please login (top right)."
        render :user_exists
      else
        @subscription = Subscription.new new_user_subscription_params
        if @subscription.save
          redirect_to root_path #subscription_path(subscription)
        else
          render :new
        end
      end
    else
      @subscription = Subscription.new existing_user_subscription_params.merge user: current_user
      if @subscription.save
        redirect_to root_path #subscription_path(subscription)
      else
        render :new
      end
    end
  end

  private

  def season
    Season.find_by_slug params[:slug]
  end

  def new_user_subscription_params
    params.require(:subscription).permit(:box_size, user_attributes: [:given_name, :surname, :email, :phone, :password]).merge season: season
  end

  def existing_user_subscription_params
    params.require(:subscription).permit(:box_size).merge season: season
  end
end