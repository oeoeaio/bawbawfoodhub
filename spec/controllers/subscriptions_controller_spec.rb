require 'rails_helper'
require 'support/controller_auth'

RSpec.describe SubscriptionsController, :type => :controller do
  include ControllerAuth

  describe 'create' do
    describe "when no remaining pack dates are available" do
      let(:season) { create(:season_without_pack_days) }
      before do
        post :create, { season_id: season.slug, subscription: { box_size: "large" } }
      end

      it "redirects to root path" do
        expect(flash[:error]).to eq "Signups for the #{season.name} season have closed."
        expect(response).to redirect_to root_path
      end
    end

    describe "when more pack dates are available" do
      let(:season) { create(:season) }

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

    describe 'token actions' do
      describe "validating tokens" do
        let(:season) { create(:season) }
        let(:rollover) { create(:rollover, season: season, confirmed_at: nil) }
        before do
          @raw_token, @token = Devise.token_generator.generate(Rollover, :confirmation_token)
          controller.instance_variable_set(:@season, season )
        end

        describe "when a token is submitted" do
          before { allow(controller).to receive(:params) { { raw_token: @raw_token } } }

          describe "and it matches an instance of Rollover" do
            before { rollover.update_attributes(confirmation_token: @token) }
            it "assigns @token and @rollover" do
              controller.send(:validate_token)
              expect(assigns(:rollover)).to eq rollover
              expect(assigns(:raw_token)).to eq @raw_token
            end
          end

          describe "and it doesn't match an instance of rollover" do
            before { rollover.update_attributes(confirmation_token: "some-other-token") }
            it "redirects to new subscriptions path" do
              expect(controller).to receive(:redirect_to).with new_season_subscription_path(season)
              controller.send(:validate_token)
            end
          end
        end

        describe "when a token is not submitted" do
          before { allow(controller).to receive(:params) { { not_a_raw_token: "token" } } }
          it "redirects to new subscriptions path" do
            expect(controller).to receive(:redirect_to).with new_season_subscription_path(season)
            controller.send(:validate_token)
          end
        end
      end

      describe "new_from_token" do
        let(:season) { create(:season) }
        let(:rollover) { create(:rollover, season: season) }

        before do
          expect(controller).to receive(:validate_token)
          controller.instance_variable_set( :@rollover, rollover )
        end

        it "instantiates a subscription object for building the form" do
          get :new_from_token, season_id: season.slug
          expect(assigns(:subscription)).to be_a_new(Subscription)
          expect(assigns(:subscription)[:box_size]).to eq rollover.subscription.box_size
        end
      end

      describe "create_from_token" do
        let(:season) { create(:season) }
        let(:rollover) { create(:rollover, season: season) }

        describe "when the token maps to a real rollover object" do
          before { allow(Rollover).to receive(:confirm_by_token) { rollover } }

          describe "and the user submits acceptable data" do
            let(:subscription_params) { { box_size: "standard" } }

            before do
              post :create_from_token, season_id: season.slug, subscription: subscription_params
            end

            it "creates a new subscription object" do
              expect(assigns(:subscription)).to be_a(Subscription)
            end

            it "render :success" do
              expect(response).to render_template :success
            end
          end

          describe "and the user submits invalid invalid data" do
            let(:subscription_params) { { box_size: "some_invalid_box_size" } }

            before do
              allow(rollover).to receive(:reset_confirmation_token!)
              post :create_from_token, season_id: season.slug, raw_token: "token", subscription: subscription_params
            end

            it "creates a new subscription object" do
              expect(assigns(:subscription)).to be_a_new(Subscription)
            end

            it "rolls back confirmation on the the rollover" do
              expect(rollover).to have_received(:reset_confirmation_token!)
            end

            it "render :new_from_token" do
              expect(response).to render_template :new_from_token
            end
          end
        end

        describe "when the token doesn't map to a rollover object" do
          before { allow(Rollover).to receive(:confirm_by_token) { Rollover.new } }
          describe "and the user submits acceptable data" do
            let(:subscription_params) { { box_size: "standard" } }

            before do
              post :create_from_token, season_id: season.slug, subscription: subscription_params
            end

            it "renders :new" do
              expect(response).to render_template :new
            end
          end
        end
      end
    end
  end
end
