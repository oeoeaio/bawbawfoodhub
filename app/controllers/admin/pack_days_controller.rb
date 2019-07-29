class Admin::PackDaysController < Admin::BaseController
  before_action :authorize_admin, only: [:index]
  before_action :load_season

  def index
    @pack_days = PackDay.where(season: @season).order(pack_date: :asc)
  end

  def new
    @pack_day = PackDay.new
    authorize_admin @pack_day
  end

  def create
    @pack_day = PackDay.new pack_day_params
    authorize_admin @pack_day
    if @pack_day.save
      flash[:success] = "New Pack Day for #{@season.name} has been created."
      redirect_to admin_season_pack_days_path(@season)
    else
      flash[:error] = "There were problems with the information you entered."
      render :new
    end
  end

  def edit
    @pack_day = PackDay.find params[:id]
    authorize_admin @pack_day
  end

  def update
    @pack_day = PackDay.find params[:id]
    authorize_admin @pack_day
    if @pack_day.update_attributes(pack_day_params)
      flash[:success] = "New Pack Day for #{@season.name} has been created."
      redirect_to admin_season_pack_days_path(@season)
    else
      flash[:error] = "There were problems with the information you entered."
      render :new
    end
  end

  private

  def pack_day_params
    params.require(:pack_day).permit(:pack_date).merge(season: @season)
  end
end
