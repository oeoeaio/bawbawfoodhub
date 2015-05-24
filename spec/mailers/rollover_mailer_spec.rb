require 'spec_helper'

RSpec.describe RolloverMailer do
  describe 'confirmation_instructions' do
    let(:season) { create(:season, name: "Summer" ) }
    let(:user) { create(:user) }
    let!(:rollover) { create(:rollover, season: season, user: user, confirmed_at: nil )}
    let!(:mail) { ActionMailer::Base.deliveries.last }

    it 'renders the subject' do
      expect(mail.subject).to eq "Signups for the #{season.name} season of veggie boxes are open now!"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ["info@bawbawfoodhub.org.au"]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hi #{user.given_name}!")
    end
  end
end
