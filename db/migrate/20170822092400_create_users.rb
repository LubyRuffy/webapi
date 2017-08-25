class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
      t.string :phone_no
      t.text  :description
      t.integer :role_id

      t.timestamps
    end
  end
end
