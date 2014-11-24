class RemoveUniqueSeasonAndUserConstraintFromSubsriptions < ActiveRecord::Migration
  def up
    remove_index :subscriptions, [:user_id, :season_id] # This one was unique
    add_index :subscriptions, [:user_id, :season_id]
  end

  def down
    remove_index :subscriptions, [:user_id, :season_id]
    add_index :subscriptions, [:user_id, :season_id], unique: true
  end
end
