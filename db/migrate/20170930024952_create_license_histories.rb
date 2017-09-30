class CreateLicenseHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :license_histories do |t|
      t.string :license

      t.timestamps
    end
  end
end
