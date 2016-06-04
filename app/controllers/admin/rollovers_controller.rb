class Admin::RolloversController < Admin::BaseController
  before_filter :authorize_admin
  before_filter :load_season, except: [:new, :create]

  def index
    @rollovers = Rollover.where(season:@season).order(confirmed_at: :desc, created_at: :desc)
  end

  def new
    @rollover = Rollover.new
    @rollover.season = Season.find_by_slug params[:season_id] if params[:season_id]
    @rollover.user = User.find_by_id params[:user_id] if params[:user_id]
  end

  def create
    @rollover = Rollover.new(rollover_params)
    @rollover.skip_confirmation_notification!

    if @rollover.save
      flash[:success] = "Successfully created a new rollover"
      redirect_to admin_season_rollovers_path(@rollover.season)
    else
      render :new
    end
  end

  def create_multiple_from_csv
    file = params[:rollovers][:file]
    if file && file.content_type == "text/csv"
      importer = RolloverImporter.new(@season, file)
      importer.import!

      flash[:success] = "Created #{importer.created_count} rollovers"

      if importer.invalid_emails.empty? && importer.ignored_emails.empty?
        redirect_to admin_season_rollovers_path(@season)
      else
        @invalid_emails = importer.invalid_emails
        @ignored_emails = importer.ignored_emails
        render :new_multiple_from_csv
      end
    else
      flash[:error] = "Invalid file format: please provide a csv"
      redirect_to multiple_new_from_csv_admin_rollover_path(@season)
    end
  end

  def new_multiple
    @subscriptions = Subscription.where(season: @season).order(created_at: :desc)
  end

  def create_multiple
    target_season = Season.find_by_slug params[:target_season_id]
    original_season = @season
    subscriptions = Subscription.where( id: params[:subscription_ids] )

    rollovers = subscriptions.map do |subscription|
      rollover = Rollover.new(season: target_season, user: subscription.user, box_size: subscription.box_size)
      rollover.skip_confirmation_notification!
      rollover
    end

    if rollovers.all?(&:save)
      redirect_to admin_season_rollovers_path(target_season)
    else
      redirect_to admin_season_subscriptions_path(original_season)
    end
  end

  def bulk_action
    rollovers = Rollover.where(id: params[:rollover_ids])
    case params[:bulk_action]
    when 'confirm', 'auto-confirm'
      Subscription.transaction do
        subscriptions = rollovers.map(&:build_subscription)
        subscriptions.each do |subscription|
          subscription.skip_confirmation_email = "yes"
          subscription.auto_rollover = true if params[:bulk_action] == 'auto-confirm'
        end
        if subscriptions.all?(&:save)
          rollovers.each(&:confirm)
          subscriptions.each{ |s| s.send(:send_confirmation) }
          flash[:success] = "Confirmed #{subscriptions.count} subscriptions"
        else
          flash[:error] = "Could not confirm all subscriptions, aborted"
        end
      end
    when 'cancel'
      rollovers.each(&:cancel)
      flash[:success] = "Cancelled #{rollovers.count} rollovers"
    when 'send'
      rollovers.each(&:send_confirmation_instructions)
      flash[:success] = "Sent #{rollovers.count} confirmation emails"
    end
    redirect_to admin_season_rollovers_path(@season)
  end

  private

  def rollover_params
    params.require(:rollover).permit(:season_id, :user_id, :box_size)
  end
end
