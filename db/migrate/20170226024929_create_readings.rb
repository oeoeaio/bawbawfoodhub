class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.belongs_to :sensor, null: false, index: true
      t.decimal :value, null: false
      t.datetime :recorded_at, null: false, index: true

      t.timestamps null: false
    end
  end
end
