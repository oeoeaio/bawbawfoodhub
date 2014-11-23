class CreateSeasons < ActiveRecord::Migration
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
