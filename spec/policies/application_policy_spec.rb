require 'rails_helper'
require 'pundit/rspec'

describe ApplicationPolicy do
  subject { described_class }

  describe "admin action permissions" do
    %w(index? show? create? new? update? edit? destroy?).each do |action|
      permissions "admin_#{action}".to_sym do
        it { expect(subject).to permit(Admin.new, :home) }
        it { expect(subject).to_not permit(User.new, :home) }
        it { expect(subject).to_not permit(nil, :home) }
      end
    end
  end

  describe "admin action permissions" do
    %w(index? show? create? new? update? edit? destroy?).each do |action|
      permissions "user_#{action}".to_sym do
        it { expect(subject).to_not permit(Admin.new, :home) }
        it { expect(subject).to permit(User.new, :home) }
        it { expect(subject).to_not permit(nil, :home) }
      end
    end
  end
end