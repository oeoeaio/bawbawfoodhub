require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do
  let(:admin) { build(:admin) }
  before { allow(controller).to receive(:current_admin).and_return admin }

  describe "new" do
    it "builds a new user and renders :new" do
      get :new
      expect(assigns(:user)).to be_a_new User
      expect(response).to render_template :new
    end
  end

  describe 'create' do
    describe "redirection" do
      let(:user) { double(:user, email: 'tiff@email.com') }
      before do
        allow(User).to receive(:new) { user }
      end

      describe 'on successful save' do
        it 'redirects to index' do
          expect(user).to receive(:save).and_return true
          post :create, { user: { given_name: 'Tiffany' } }
          expect(response).to redirect_to admin_users_path
          expect(flash[:success]).to eq "Created new user: tiff@email.com"
        end
      end

      describe 'on unsuccessful save' do
        it 'returns to new' do
          expect(user).to receive(:save).and_return false
          post :create, { user: { given_name: 'Tiffany' } }
          expect(response).to render_template :new
        end
      end
    end

    describe "creation" do
      let(:user_params) { { given_name: 'Tiffany', surname: 'Greenwood', phone: '12345678', email: 'tiff@email.com' } }
      it "creates a new user with an automatically generated password" do
        expect(Devise).to receive(:friendly_token) { "1234567890" }
        expect(User).to receive(:new).with(user_params.merge( password: '1234567890', password_confirmation: '1234567890')).and_call_original
        expect{post :create, { user: user_params } }.to change{User.count}.by(1)
      end

      it "creates a new user without an initalised_at timestamp" do
        user_params.merge!(skip_initialisation: true)
        expect{post :create, { user: user_params } }.to change{User.count}.by(1)
        expect(assigns(:user).initialised_at).to be_nil
      end
    end
  end

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
