class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :corporate_name
      t.string :brand_name
      t.string :registration_number
      t.string :number_phone
      t.string :email
      t.string :full_address
      t.string :neighborhood
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :description
      t.boolean :accepts_cash
      t.boolean :accepts_pix
      t.boolean :accepts_credit_card

      t.timestamps
    end
  end
end
