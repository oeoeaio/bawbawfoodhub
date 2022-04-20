class Admin::JobsController < Admin::BaseController
  before_action :authorize_admin, only: [:index, :new, :create]

  def index
    @jobs = Job.order(created_at: :asc)
    render :index
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:success] = "Successfully created a new Job"
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find_by_slug params[:id]
    authorize_admin @job
  end

  def update
    @job = Job.find_by_slug params[:id]
    authorize_admin @job

    if @job.update(job_params)
      flash[:success] = "Job updated successfully"
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  private

  def job_params
    params.require(:job).permit(:title, :slug, :closes_at, :description)
  end
end
