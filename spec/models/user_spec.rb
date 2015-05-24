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

  describe "callbacks" do
    describe "initialisation" do
      context "creation" do
        let!(:user) { User.new(given_name: "Todd", surname: "Summers", email: "todd@email.com", password: "12345678", password_confirmation: "12345678") }

        context "when skip_initialisation is not set" do
          it "sets initialised_at" do
            expect{user.save}.to change{user.initialised_at}.from(nil)
          end
        end

        context "when skip_initialisation is not set" do
          before { user.skip_initialisation = "yes" }
          it "does not set initialised_at" do
            expect{user.save}.to_not change{user.initialised_at}.from(nil)
          end
        end

      end
      context "updating" do
        let(:user) { create(:user, skip_initialisation: "yes")}
        before { user.skip_initialisation = "no" }

        it "sets initialised_at if password is changed" do
          expect do
            user.password = "lalalala"
            user.password_confirmation = "lalalala"
            user.save
          end.to change{user.initialised_at}.from(nil)
        end

        it "does not set initialised_at if password is not changed" do
          expect do
            user.given_name = "Tony"
            user.save
          end.to_not change{user.initialised_at}.from(nil)
        end
      end
    end
  end
end
