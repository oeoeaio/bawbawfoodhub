class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.belongs_to :season, index: true
      t.belongs_to :user, index: true
      t.string :box_size

      t.timestamps
    end
    add_index :signups, [:user_id, :season_id], unique: true
  end
end
