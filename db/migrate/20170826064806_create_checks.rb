class CreateChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :checks do |t|
      t.string :name

      t.timestamps
    end
  end
end
