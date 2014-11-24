class SeasonsController < ApplicationController
  before_filter :load_season


  private

  def load_season
    @season = Season.find_by_slug params[:id]
    if @season.nil?
      flash[:error] = "No season by that name exists"
      redirect_to root_path
    end
  end
end