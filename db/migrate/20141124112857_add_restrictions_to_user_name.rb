class AddRestrictionsToUserName < ActiveRecord::Migration
  def change
    change_column :users, :given_name, :string, default: '', null: false
    change_column :users, :surname, :string, default: '', null: false
  end
end
