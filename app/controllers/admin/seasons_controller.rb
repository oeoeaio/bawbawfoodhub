class Admin::SeasonsController < Admin::BaseController
  def index
    @seasons = Season.all
    authorize Season, :admin_index?
  end
end