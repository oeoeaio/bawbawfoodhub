require 'rails_helper'
require 'pundit/rspec'

describe HomePolicy do
  subject { described_class }

  permissions :admin_index? do
    it "permits access if user is an admin" do
      expect(subject).to permit(Admin.new, :home)
    end

    it "denies access if user is another user class" do
      expect(subject).to_not permit(User.new, :home)
    end

    it "denies access if user is nil" do
      expect(subject).to_not permit(nil, :home)
    end
  end
end