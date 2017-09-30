class CreateLicenses < ActiveRecord::Migration[5.1]
  def change
    create_table :licenses do |t|
      t.string     :license
      t.datetime :valid_time
      t.datetime :activate_time
      t.datetime :expired_time
      t.boolean    :activated

      t.timestamps
    end
  end
end
