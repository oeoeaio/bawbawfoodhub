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
    url = "https://recaptchaenterprise.googleapis.com/v1/projects/#{Rails.application.secrets.recaptcha_enterprise_project_id}/assessments"
    response = HTTParty.post(
      url,
      headers: { 'Content-Type' => 'application/json' },
      query: {
        key: Rails.application.secrets.recaptcha_enterprise_api_key,
      },
      body: {
        event: {
          token: params[:recaptcha_token],
          siteKey: Rails.application.secrets.recaptcha_site_key,
        }
      }.to_json
    )

    return if response['tokenProperties']['action'] == 'contact' && response['riskAnalysis']['score'] > 0.5
    Rails.logger.warn("reCAPTCHA failed for token: #{params[:recaptcha_token]}")
    Rails.logger.warn(response.inspect)
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
