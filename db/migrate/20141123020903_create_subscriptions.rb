class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :season, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.string :box_size

      t.timestamps
    end
    add_index :subscriptions, [:user_id, :season_id], unique: true
  end
end
