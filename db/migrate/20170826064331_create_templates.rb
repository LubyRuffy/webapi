class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.string :name
      t.text :checks
      t.integer :ref

      t.timestamps
    end
  end
end
