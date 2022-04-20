require 'mail'

class SubscriptionMailer < ActionMailer::Base
  layout 'mail'
  include Roadie::Rails::Automatic
  helper(ApplicationHelper)
  helper(SubscriptionHelper)

  def confirmation(subscription)
    @subscription = subscription
    @season = subscription.season
    @subject = "Thanks! You'll be receiving a #{subscription.frequency} #{Subscription::SIZES[subscription.box_size][:name]} from the Baw Baw Food Hub!"
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
