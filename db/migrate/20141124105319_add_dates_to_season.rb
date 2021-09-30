class AddDatesToSeason < ActiveRecord::Migration[4.2]
  def change
    add_column :seasons, :starts_on, :date
    add_column :seasons, :ends_on, :date
  end
end
