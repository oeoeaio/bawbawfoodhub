class ContactController < ApplicationController
  def index
    @contact = Contact.new({})
  end

  def submit
    verify_recaptcha_token
    @contact = Contact.new params[:contact]
    if @contact.valid?
      if ContactMailer.query(@contact).deliver
        flash[:notice] = "Your email has been sent! We'll get back to you as soon as we can."
        redirect_to contact_path
      end
    else
      flash.now[:error] = "There was a problem submitting your email. Please review the form for errors."
      render :index
    end
  end

  private

  def verify_recaptcha_token
    response = HTTParty.post("https://www.google.com/recaptcha/api/siteverify",
      query: {
        secret: Rails.application.secrets.recaptcha_secret_key,
        response: params[:token]
      }
    )

    puts "reCAPTCHA RESPONSE: #{response}"
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
