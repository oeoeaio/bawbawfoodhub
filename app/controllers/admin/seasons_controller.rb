class Admin::SeasonsController < Admin::BaseController
  before_filter :authorize_admin, only: [:index, :new, :create]

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

  private

  def season_params
    params.require(:season).permit(:name, :slug, :places_remaining, :signups_open)
  end
end