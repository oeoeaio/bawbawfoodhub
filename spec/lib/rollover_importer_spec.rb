require 'rails_helper'

RSpec.describe RolloverImporter do
  describe "importing a basic list" do
    let(:season) { create(:season) }
    let!(:existing_user) { create(:user, given_name: "Jim", surname: "Stevens", email: 'existing@email.com', phone: "54321") }
    let!(:existing_rollover_user) { create(:user, given_name: "Charlie", surname: "Higgins", email: 'charlie@email.com', phone: "12345") }
    let!(:existing_rollover) { create(:rollover, user: existing_rollover_user, season: season, box_size: "small")}

    let(:importer) { RolloverImporter.new(season, nil) }
    let(:rows_mock) { [
      { given_name: "Tim", surname: "Stephens", email: 'existing@email.com', phone: "12345", box_size: "Large Box" },
      { given_name: "Charlie", surname: "Higgins", email: 'charlie@email.com', phone: "12345", box_size: "Large Box" },
      { given_name: "Jane", surname: "Rogers", email: 'non-existing@email.com', phone: "54321", box_size: "Standard Box" },
      { given_name: "Invalid", surname: "Boxsize", email: 'some@email.com', phone: "12345", box_size: "Invalid Box" },
      { given_name: "", surname: "No Given Name", email: 'new@email.com', phone: "12345", box_size: "Large Box" }
    ] }

    before do
      allow(importer).to receive(:csv_rows) { rows_mock }
      expect{importer.import!}.to_not change{ ActionMailer::Base.deliveries.count }
    end

    it "creates new users" do
      user = User.find_by_email('non-existing@email.com')
      expect(user.given_name).to eq "Jane"
      expect(user.surname).to eq "Rogers"
      expect(user.phone).to eq "54321"

      # Creates a new rollover
      expect(Rollover.where(user: user).count).to be 1
    end

    it "preserves information for users that already exist" do
      user = User.find_by_email('existing@email.com')
      expect(user).to eq existing_user
      expect(user.given_name).to eq "Jim"
      expect(user.surname).to eq "Stevens"
      expect(user.phone).to eq "54321"
    end

    it "does not create a new rollover for a user if one already exists" do
      expect(Rollover.where(user: existing_rollover_user, season: season).count).to eq 1
      rollover = Rollover.find_by(user: existing_rollover_user, season: season)
      expect(rollover).to eq existing_rollover
    end

    it "ignore invalid rows" do
      expect(importer.created_count).to be 2
      expect(importer.invalid_emails.count).to be 2
      expect(importer.ignored_emails.count).to be 1
      expect(User.find_by_email('existing@email.com')).to be_a User
      expect(User.find_by_email('charlie@email.com')).to be_a User
      expect(User.find_by_email('non-existing@email.com')).to be_a User
      expect(User.find_by_email('some@email.com')).to be nil
      expect(User.find_by_email('new@email.com')).to be nil
    end
  end
end
