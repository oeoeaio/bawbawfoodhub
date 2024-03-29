class Admin::SeasonsController < Admin::BaseController
  before_action :authorize_admin, only: [:index, :new, :create]

  def index
    @seasons = Season.all
  end

  def new
    @season = Season.new
  end

  def create
    season = Season.new season_params
    if season.save!
      redirect_to admin_seasons_path
    else
      render :new
    end
  end

  def edit
    @season = Season.find_by_slug params[:id]
    authorize_admin @season
  end

  def update
    season = Season.find_by_slug params[:id]
    authorize_admin season
    if season.update! season_params
      redirect_to admin_seasons_path
    else
      render :edit
    end
  end

  def populate
    season = Season.find_by_slug params[:id]
    authorize_admin season
    populator = SeasonPopulator.new(season: season)
    populator.run
    flash[:notice] = populator.message
    redirect_to admin_season_pack_days_path(season)
  end

  private

  def season_params
    params.require(:season).permit(:name, :slug, :starts_on, :ends_on, :places_remaining, :signups_open)
  end
end
