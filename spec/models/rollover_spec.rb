require 'rails_helper'

RSpec.describe Rollover, :type => :model do
  it { expect(subject).to validate_presence_of :season }
  it { expect(subject).to validate_presence_of :user }

  describe "sending email after save" do
    # Technically this is mostly testing devise logic, but we've fiddled
    # with it a bit, so probably good to double check that it's working.

    it "sends an email after save" do
      rollover = Rollover.new(season: create(:season), user: create(:user), box_size: 'large')
      mail_message_mock = double(:mail_message)
      expect(RolloverMailer).to receive(:confirmation_instructions).once { mail_message_mock }
      expect(mail_message_mock).to receive(:deliver).once
      rollover.save!
    end
  end
end
