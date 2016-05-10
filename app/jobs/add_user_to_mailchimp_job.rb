class AddUserToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    Mailchimp::Api.add_to_list(user)
  end
end
