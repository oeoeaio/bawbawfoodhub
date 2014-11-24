class SeasonsController < ApplicationController
  def show
    @season = Season.find_by_slug params[:slug]
  end
end