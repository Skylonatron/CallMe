class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :phone_number_2
      t.string :email
      t.integer :called, default: 0, null: false

      t.timestamps
    end
  end
end
