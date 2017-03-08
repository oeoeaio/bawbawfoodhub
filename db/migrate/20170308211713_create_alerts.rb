class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.belongs_to :sensor, null: false, index: true
      t.string :category, null: false, index: true
      t.datetime :sleep_until, index: true
      t.datetime :resolved_at, index: true
      t.timestamps null: false
    end
  end
end
