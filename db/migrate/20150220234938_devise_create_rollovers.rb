class DeviseCreateRollovers < ActiveRecord::Migration[4.2]
  def change
    create_table(:rollovers) do |t|
      t.belongs_to :season, null: false
      t.belongs_to :subscription, null: false

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end

    add_index :rollovers, :confirmation_token,   unique: true
  end
end
