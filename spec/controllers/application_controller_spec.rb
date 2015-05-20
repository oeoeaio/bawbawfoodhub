require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do

  describe "validating rollover tokens" do
    let(:season) { create(:season) }
    let(:rollover) { create(:rollover, season: season, confirmed_at: nil) }
    before do
      @raw_token, @token = Devise.token_generator.generate(Rollover, :confirmation_token)
      controller.instance_variable_set(:@season, season )
    end

    context "when a token is submitted" do
      before { allow(controller).to receive(:params) { { raw_token: @raw_token } } }

      context "and it matches an instance of Rollover" do
        before { rollover.update_attributes(confirmation_token: @token) }
        it "assigns @token and @rollover" do
          controller.send(:validate_rollover_token)
          expect(assigns(:rollover)).to eq rollover
          expect(assigns(:raw_token)).to eq @raw_token
        end
      end

      context "and it doesn't match an instance of rollover" do
        before { rollover.update_attributes(confirmation_token: "some-other-token") }
        it "redirects to new subscriptions path" do
          allow(controller).to receive(:invalid_rollover_token)
          controller.send(:validate_rollover_token)
        end
      end
    end

    context "when a token is not submitted" do
      before { allow(controller).to receive(:params) { { not_a_raw_token: "token" } } }
      it "redirects to new subscriptions path" do
        allow(controller).to receive(:invalid_rollover_token)
        controller.send(:validate_rollover_token)
      end
    end
  end
end
