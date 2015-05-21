RSpec.describe RolloversController, :type => :controller do
  describe 'cancel' do
    context "when a token is submitted" do
      let(:rollover) { create(:rollover) }
      let(:params) { { raw_token: "some_token" } }

      it "cancels the rollover in question" do
        expect(Rollover).to receive(:find_by_confirmation_token) { rollover }
        get :cancel, params
        expect(assigns(:rollover)).to eq rollover
        expect(rollover.cancelled?).to be_truthy
      end
    end

    context "when a token is not submitted" do
      it "redirect to the root path" do
        get :cancel
        expect(response).to redirect_to root_path
      end
    end
  end
end
