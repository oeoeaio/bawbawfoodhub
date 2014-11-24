require 'rails_helper'
require 'pundit/rspec'

describe HomePolicy do
  subject { described_class }

  it "should inherit from ApplicationPolicy" do
    expect(subject.superclass).to be ApplicationPolicy
  end
end