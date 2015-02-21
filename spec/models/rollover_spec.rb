require 'rails_helper'

RSpec.describe Rollover, :type => :model do
  it { expect(subject).to validate_presence_of :season }
  it { expect(subject).to validate_presence_of :subscription }
end
