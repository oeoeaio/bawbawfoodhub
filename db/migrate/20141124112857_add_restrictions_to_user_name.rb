class AddRestrictionsToUserName < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :given_name, :string, default: '', null: false
    change_column :users, :surname, :string, default: '', null: false
  end
end
