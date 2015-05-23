require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do
  let(:admin) { build(:admin) }
  before { allow(controller).to receive(:current_admin).and_return admin }

  describe 'update' do
    let(:user) { double(:user, class: User) }
    before do
      allow(User).to receive(:find) { user }
    end

    describe 'on successful update' do
      it 'redirects to index' do
        expect(user).to receive(:update_attributes).and_return true
        put :update, { id: 1, user: { given_name: 'Priscilla' } }
        expect(response).to redirect_to admin_users_path
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to edit' do
        expect(user).to receive(:update_attributes).and_return false
        put :update, { id: 1, user: { given_name: 'Priscilla' } }
        expect(response).to render_template :edit
      end
    end
  end
end
