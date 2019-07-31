class RemoveCms1120 < ActiveRecord::Migration[5.0]
  def up
    drop_table :comfy_cms_sites
    drop_table :comfy_cms_layouts
    drop_table :comfy_cms_pages
    drop_table :comfy_cms_blocks
    drop_table :comfy_cms_snippets
    drop_table :comfy_cms_files
    drop_table :comfy_cms_revisions
    drop_table :comfy_cms_categories
    drop_table :comfy_cms_categorizations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
