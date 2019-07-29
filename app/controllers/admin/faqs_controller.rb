class Admin::FaqsController < Admin::BaseController
  before_action :authorize_admin, only: [:index, :new, :create]
  before_action :load_faq_group, only: [:index]

  def index
    @faqs = Faq.where(faq_group: @faq_group).order(created_at: :asc)
    render :index
  end

  def new
    @faq = Faq.new
    @faq.faq_group = FaqGroup.find params[:faq_group_id] if params[:faq_group_id]
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      flash[:success] = "Successfully created a new FAQ"
      redirect_to admin_faq_group_faqs_path(@faq.faq_group)
    else
      render :new
    end
  end

  def edit
    @faq = Faq.find params[:id]
    authorize_admin @faq
  end

  def update
    @faq = Faq.find params[:id]
    authorize_admin @faq

    if @faq.update_attributes(update_faq_params)
      flash[:success] = "FAQ updated successfully"
      redirect_to admin_faq_group_faqs_path(@faq.faq_group)
    else
      render :edit
    end
  end

  private

  def faq_params
    params.require(:faq).permit(:faq_group_id, :question, :answer)
  end

  def update_faq_params
    params.require(:faq).permit(:question, :answer)
  end

  def load_faq_group
    @faq_group = FaqGroup.find params[:faq_group_id]
    if @faq_group.nil?
      flash[:error] = "FAQ Group not found"
      redirect_to admin_root_path
    end
  end
end
