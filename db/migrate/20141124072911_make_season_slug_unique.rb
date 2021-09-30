class MakeSeasonSlugUnique < ActiveRecord::Migration[4.2]
  def change
    add_index :seasons, :slug, :unique => true
  end
end
