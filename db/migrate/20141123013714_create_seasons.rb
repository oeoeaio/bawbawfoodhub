class CreateSeasons < ActiveRecord::Migration[4.2]
  def change
    create_table :seasons do |t|
      t.string :name
      t.string :slug
      t.boolean :signups_open
      t.integer :places_remaining

      t.timestamps
    end
  end
end
