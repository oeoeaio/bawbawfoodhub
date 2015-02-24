require 'spec_helper'

RSpec.describe RolloverMailer do
  describe 'confirmation_instructions' do
    let(:original_season) { create(:season, name: "Spring" ) }
    let(:season) { create(:season, name: "Summer" ) }
    let(:subscription) { create(:subscription, season: original_season) }
    let!(:rollover) { create(:rollover, season: season, subscription: subscription, confirmed_at: nil )}
    let!(:mail) { ActionMailer::Base.deliveries.last }

    it 'renders the subject' do
      expect(mail.subject).to eq "Signups for the #{season.name} season of veggie boxes are open now!"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [subscription.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ["info@bawbawfoodhub.org.au"]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hi #{subscription.user.given_name}!")
    end
  end
end
