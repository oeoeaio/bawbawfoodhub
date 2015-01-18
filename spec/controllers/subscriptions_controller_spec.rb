require 'rails_helper'
require 'support/controller_auth'

RSpec.describe SubscriptionsController, :type => :controller do
  include ControllerAuth

  describe 'create' do
    describe "when no remaining pack dates are available" do
      let(:season) { create(:season) }
      before do
        post :create, { season_id: season.slug, subscription: { box_size: "large" } }
      end

      it "redirects to root path" do
        expect(flash[:error]).to eq "Signups for the #{season.name} season have closed."
        expect(response).to redirect_to root_path
      end
    end

    describe "when more pack dates are available" do
      let(:season) { create(:season_with_pack_days) }

      describe "but signups are closed" do
        before do
          season.signups_open = false
          season.save!
          post :create, { season_id: season.slug, subscription: { box_size: "large" } }
        end

        it "redirects to root path" do
          expect(flash[:error]).to eq "Signups for the #{season.name} season have closed."
          expect(response).to redirect_to root_path
        end
      end

      describe 'with nested_attributes for' do
        describe 'a new user (unrecognised email address)' do
          let(:user_attributes) { { given_name: "Frida", surname: "Delaware", email: "unknown@email.com", password: "12345678", password_confirmation: "12345678"} }
          before do
            post :create, { season_id: season.slug, subscription: { box_size: "large", user_attributes: user_attributes } }
          end

          it "creates a new user" do
            expect(User.find_by_email('unknown@email.com')).to be_a User
          end

          it "creates a new subscription" do
            expect(Subscription.where(season: season, user: User.find_by_email('unknown@email.com')).length).to be 1
          end
        end

        describe 'an existing user (recognised email address)' do
          let(:user) { create(:user) }
          let(:user_attributes) { { given_name: "Frida", surname: "Delaware", email: user.email, password: "12345678", password_confirmation: "12345678"} }

          it "notifies the user" do
            post :create, { season_id: season.slug, subscription: { box_size: "large", user_attributes: user_attributes } }
            expect(response).to render_template :user_exists
            expect(flash[:error]).to eq "The user '#{user.email}' already exists, to manage subscriptions for this user, please login (top right)."
            expect(assigns(:email)).to eq user.email
          end
        end
      end

      describe "without nested attributes for a user" do
        describe "when the user is logged in" do
          let!(:user) { login_user }

          it "creates a new subscription" do
            post :create, { season_id: season.slug, subscription: { box_size: "large" } }
            expect(Subscription.where(season: season, user: user).length).to be 1
          end
        end

        describe "when no user is logged in" do
          before do
            allow(controller).to receive(:current_user).and_return nil
            post :create, { season_id: season.slug, subscription: { box_size: "large" } }
          end

          it "renders the new page with errors" do
            expect(response).to render_template :new
            expect(assigns(:subscription).errors.full_messages_for(:user)).to eq ["User can't be blank"]
          end
        end
      end
    end

  end
end
