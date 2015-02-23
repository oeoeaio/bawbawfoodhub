require 'mail'

class RolloverMailer < ActionMailer::Base
  layout 'mail'
  include Roadie::Rails::Automatic

  def confirmation_instructions(rollover, raw_token)
    @subscription = rollover.subscription
    @season = rollover.season
    @raw_token = raw_token
    subject = "You can sign up for the #{@season.name} season of veggie boxes now!"
    address = Mail::Address.new @subscription.user.email
    address.display_name = "#{@subscription.user.given_name} #{@subscription.user.surname}"
    mail(
    to: address.format,
    bcc: Rails.application.secrets.admin_email,
    from: "Baw Baw Food Hub <#{Rails.application.secrets.admin_email}>",
    subject: subject
    )
  end
end
