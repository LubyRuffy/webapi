class CreateSitemaps < ActiveRecord::Migration[5.1]
  def change
    create_table :sitemaps do |t|
      t.integer :scan_id
      t.text :sitemap

      t.timestamps
    end
  end
end
