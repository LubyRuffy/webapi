class CreateDiskchecks < ActiveRecord::Migration[5.1]
  def change
    create_table :diskchecks do |t|
      t.integer :db_limit
      t.integer :report_limit

      t.timestamps
    end
  end
end
