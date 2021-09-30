class AddInitialisedAtToUsers < ActiveRecord::Migration[4.2]
  def change
    # Represents the time at which a user initialised their account by setting a password
    add_column :users, :initialised_at, :datetime

    # Set to create_at for all existing users
    User.update_all('initialised_at=created_at')
  end
end
