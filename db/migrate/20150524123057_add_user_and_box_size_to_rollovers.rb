class AddUserAndBoxSizeToRollovers < ActiveRecord::Migration
  def change
    add_column :rollovers, :user_id, :integer
    add_column :rollovers, :box_size, :string

    ActiveRecord::Base.connection.execute("UPDATE rollovers r SET user_id = s.user_id, box_size = s.box_size FROM subscriptions s WHERE r.subscription_id = s.id")

    change_column :rollovers, :user_id, :integer, null: false, index: true
  end
end
