require 'mail'

class RolloverMailer < ActionMailer::Base
  layout 'mail'
  include Roadie::Rails::Automatic
  helper ApplicationHelper

  def confirmation_instructions(rollover, raw_token)
    @rollover = rollover
    @season = rollover.season
    @raw_token = raw_token
    subject = "Signups for the #{@season.name} season of veggie boxes are open now!"
    address = Mail::Address.new @rollover.user.email
    address.display_name = "#{@rollover.user.given_name} #{@rollover.user.surname}"
    mail(
    to: address.format,
    bcc: Rails.application.secrets.admin_email,
    from: "Baw Baw Food Hub <#{Rails.application.secrets.admin_email}>",
    subject: subject
    )
  end
end
