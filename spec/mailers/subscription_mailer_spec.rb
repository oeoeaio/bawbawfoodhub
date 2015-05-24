require 'spec_helper'

RSpec.describe SubscriptionMailer do
  describe 'confirmation' do
    let(:season) { create(:season, name: "Summer" ) }
    let(:subscription) { create(:subscription, season: season) }
    let(:mail) { SubscriptionMailer.confirmation(subscription) }

    it 'renders the subject' do
      expect(mail.subject).to eq "Thanks! You are now signed up for the #{season.name} season of veggie boxes from Baw Baw Food Hub"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [subscription.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ["info@bawbawfoodhub.org.au"]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Thanks #{subscription.user.given_name}!")
    end
  end
end
