require 'spec_helper'

RSpec.describe SubscriptionMailer do
  describe 'confirmation' do
    let(:season) { create(:season, name: "Summer" ) }
    let(:subscription) { create(:subscription, season: season) }
    let(:mail) { SubscriptionMailer.confirmation(subscription) }

    it 'renders the subject' do
      expect(mail.subject).to eq "Thanks! You'll be receiving a weekly Large Box from the Baw Baw Food Hub!"
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

    context 'when auto_rollover on the subscription is set to true' do
      before do
        allow(subscription).to receive(:auto_rollover) { true }
      end

      it 'notifies the user that they are being automatically rolled over' do
        expect(mail.body.encoded).to match("Your subscription has been rolled over to the #{season.name} season because we have not heard from you otherwise.")
      end
    end
  end
end
