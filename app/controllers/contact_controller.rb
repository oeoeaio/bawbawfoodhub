class ContactController < ApplicationController
  before_action :verify_recaptcha_token, only: :submit

  def index
    @contact = Contact.new({})
  end

  def submit
    @contact = Contact.new params[:contact]
    if @contact.valid?
      if ContactMailer.query(@contact).deliver
        render :success
      end
    else
      flash.now[:error] = "There was a problem submitting your email. Please review the form for errors."
      render :index
    end
  end

  private

  def verify_recaptcha_token
    return if verify_recaptcha
    Rails.logger.info("reCAPTCHA failed for token: #{params['g-recaptcha-response']}")
    render :sorry
  end

  class Contact
    include ActiveModel::Validations
    attr_accessor :email, :name, :subject, :body
    validates :email, presence: true, format: { with: /\A[^@]+@[^@]+\.[^@]+\z/ }
    validates :body, presence: true

    def initialize(attr)
      @email = attr[:email]
      @name = attr[:name]
      @subject = attr[:subject]
      @body = attr[:body]
    end
  end
end
