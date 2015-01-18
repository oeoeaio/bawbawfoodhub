require 'mail'

class SubscriptionMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(SubscriptionHelper)

  def confirmation(subscription)
    @subscription = subscription
    @season = subscription.season
    @subject = "Thanks! You are now signed up for the #{subscription.season.name} season of veggie boxes from Baw Baw Food Hub"
    address = Mail::Address.new subscription.user.email
    address.display_name = "#{subscription.user.given_name} #{subscription.user.surname}"
    mail(
    to: address.format,
    bcc: Rails.application.secrets.admin_email,
    from: "Baw Baw Food Hub <#{Rails.application.secrets.admin_email}>",
    subject: @subject
    )
  end
end
