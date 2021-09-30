class CreatePackDays < ActiveRecord::Migration[4.2]
  def change
    create_table :pack_days do |t|
      t.belongs_to :season, index: true, null: false
      t.date :pack_date, null: false

      t.timestamps
    end
  end
end
