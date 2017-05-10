class JobsController < ApplicationController
  def show
    @job = Job.find_by_slug params[:id]
  end
end
