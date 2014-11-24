require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "associations" do
    describe "subscriptions" do
      let!(:user){ create(:user) }
      let!(:subscription1) { create(:subscription, user: user) }
      let!(:subscription2) { create(:subscription) }

      it "finds subscriptions for a user" do
        expect(user.subscriptions).to eq [subscription1]
      end
    end
  end

  describe "validations" do
    it "requires names" do
      expect(build(:user, given_name: nil, surname: nil)).to be_invalid
      expect(build(:user, given_name: "", surname: "")).to be_invalid
      expect(build(:user, given_name: "", surname: "Pickle")).to be_invalid
      expect(build(:user, given_name: "Peter", surname: "")).to be_invalid
      expect(build(:user, given_name: "Peter", surname: "Pickle")).to be_valid
    end

    it "requires email" do
      expect(build(:user, email: nil)).to be_invalid
      expect(build(:user, email: "")).to be_invalid
      expect(build(:user, email: "not_an_email_addess")).to be_invalid
      expect(build(:user, email: "lala@lala.com")).to be_valid
    end

    it "requires email" do
      expect(build(:user, password: nil)).to be_invalid
      expect(build(:user, password: "")).to be_invalid
      expect(build(:user, password: "password")).to be_valid
    end
  end
end
