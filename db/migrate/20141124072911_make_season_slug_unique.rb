class MakeSeasonSlugUnique < ActiveRecord::Migration
  def change
    add_index :seasons, :slug, :unique => true
  end
end
