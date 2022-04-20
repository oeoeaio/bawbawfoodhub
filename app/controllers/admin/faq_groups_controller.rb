class Admin::FaqGroupsController < Admin::BaseController
  before_action :authorize_admin, only: [:index, :new, :create]

  def index
    @faq_groups = FaqGroup.all
  end

  def new
    @faq_group = FaqGroup.new
  end

  def create
    faq_group = FaqGroup.new faq_group_params
    if faq_group.save!
      redirect_to admin_faq_groups_path
    else
      render :new
    end
  end

  def edit
    @faq_group = FaqGroup.find params[:id]
    authorize_admin @faq_group
  end

  def update
    faq_group = FaqGroup.find params[:id]
    authorize_admin faq_group
    if faq_group.update! faq_group_params
      redirect_to admin_faq_groups_path
    else
      render :edit
    end
  end

  private

  def faq_group_params
    params.require(:faq_group).permit(:title)
  end
end
