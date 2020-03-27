require 'rails_helper'
require 'support/controller_auth'

RSpec.describe SubscriptionsController, :type => :controller do
  include ControllerAuth

  describe 'new' do
    let(:season) { create(:season) }
    let(:params) { { season_id: season.slug } }

    it "instantiates the @subscription object for building the form" do
      get :new, params: params
      expect(assigns(:subscription)).to be_a_new(Subscription)
      expect(assigns(:subscription)[:box_size]).to eq ""
    end

    it "instantiates the @user object for building the form" do
      get :new, params: params
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'create' do
    before do
      allow(controller).to receive(:verify_recaptcha_token) # Stubbing out, because we don't care about verification
    end

    context "when no remaining pack dates are available" do
      let(:season) { create(:season_without_pack_days) }
      before do
        post :create, params: { season_id: season.slug, subscription: { box_size: "large" } }
      end

      it "redirects to root path" do
        expect(flash[:error]).to eq "Signups for the #{season.name} season have closed."
        expect(response).to redirect_to root_path
      end
    end

    describe "when more pack dates are available" do
      context "but signups are closed" do
        let(:season) { create(:season) }

        before do
          season.signups_open = false
          season.save!
          post :create, params: { season_id: season.slug, subscription: { box_size: "large" } }
        end

        it "redirects to root path" do
          expect(flash[:error]).to eq "Signups for the #{season.name} season have closed."
          expect(response).to redirect_to root_path
        end
      end

      describe 'with nested_attributes for' do
        let(:season) { create(:season) }
        describe 'a new user (unrecognised email address)' do
          let(:user_attributes) { { given_name: "Frida", surname: "Delaware", email: "unknown@email.com", password: "12345678", password_confirmation: "12345678"} }
          before do
            post :create, params: { season_id: season.slug, subscription: { box_size: "large", frequency: 'weekly', day_of_week: "wednesday", delivery: 'false', user_attributes: user_attributes } }
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
          let(:params) { { season_id: season.slug, subscription: { box_size: "large", frequency: "weekly", day_of_week: "wednesday", delivery: "false", user_attributes: user_attributes } } }

          before do
            allow(controller).to receive(:sign_in) # Stubbing out, because we don't have Warden
            allow(controller).to receive(:current_user) { user }
          end

          context "and the password submitted is invalid" do
            let(:subscription) { double(:subscription) }

            before do
              allow(User).to receive(:find_by_email) { user }
              allow(user).to receive(:valid_password?) { false }
            end

            it "assigns @subscription" do
              post :create, params: params
              expect(assigns(:subscription)).to be_a_new(Subscription)
            end

            context "and the subscription is valid" do
              before do
                allow(Subscription).to receive(:new) { subscription }
                allow(subscription).to receive(:valid?) { true }
                post :create, params: params
              end

              it "assigns @user" do
                expect(assigns(:user)).to eq user
              end

              it "renders :user_exists" do
                expect(response).to render_template :user_exists
              end
            end

            context "and the subscription is invalid" do
              before do
                allow(Subscription).to receive(:new) { subscription }
                allow(subscription).to receive(:valid?) { false }
                post :create, params: params
              end

              it "renders :new" do
                post :create, params: params
                expect(response).to render_template :new
              end
            end
          end

          context "and a valid password submitted" do
            before do
              allow(User).to receive(:find_by_email) { user }
              allow(user).to receive(:valid_password?) { true }
            end

            context "when the user already has an existing subscription for this season" do
              let!(:subscription) { create(:subscription, season: season, user: user) }

              context "and the subscription is valid" do
                context "and the user has not confirmed creation of this subscription" do
                  before { post :create, params: params }

                  it "assigns @subscription" do
                    expect(assigns(:subscription)).to be_a_new(Subscription)
                  end

                  it "assigns @existing_subscription" do
                    expect(assigns(:existing_subscription)).to eq subscription
                  end

                  it "renders :confirm" do
                    expect(response).to render_template :confirm
                  end
                end

                context "but the user has already confirmed creation of this subscription" do
                  before do
                    params.merge!({ confirmed: true })
                    post :create, params: params
                  end

                  it "renders :success" do
                    expect(response).to render_template :success
                  end
                end
              end

              context "and the subscription is invalid" do
                before do
                  params[:subscription].merge!(delivery: true)
                  post :create, params: params
                end

                it "assigns @user" do
                  expect(assigns(:user)).to eq user
                end

                it "renders :new" do
                  expect(response).to render_template :new
                end
              end
            end

            context "when the user has no existing subscriptions for this season" do
              let(:subscription) { double(:subscription) }
              before { allow(Subscription).to receive(:new) { subscription } }
              context "and the subscription saves" do
                before do
                  allow(subscription).to receive(:save) { true }
                  post :create, params: params
                end

                it "renders :success" do
                  expect(response).to render_template :success
                end
              end

              context "and the subscription does not save" do
                before do
                  allow(subscription).to receive(:save) { false }
                  post :create, params: params
                end

                it "assigns @user" do
                  expect(assigns(:user)).to eq user
                end

                it "renders :new" do
                  expect(response).to render_template :new
                end
              end
            end
          end
        end
      end

      context "without nested attributes for a user" do
        let(:season) { create(:season) }
        context "when the user is logged in" do
          let!(:user) { login_user }

          it "creates a new subscription" do
            post :create, params: { season_id: season.slug, subscription: { box_size: "large", frequency: "weekly", day_of_week: "wednesday", delivery: "false" } }
            expect(Subscription.where(season: season, user: user).length).to be 1
          end
        end

        context "when no user is logged in" do
          before do
            allow(controller).to receive(:current_user).and_return nil
            post :create, params: { season_id: season.slug, subscription: { box_size: "large", frequency: "weekly", day_of_week: "wednesday", delivery: "false" } }
          end

          it "renders the new page with errors" do
            expect(response).to render_template :new
            expect(assigns(:subscription).errors.full_messages_for(:user)).to eq ["User must exist", "User can't be blank"]
          end
        end
      end
    end
  end
end
