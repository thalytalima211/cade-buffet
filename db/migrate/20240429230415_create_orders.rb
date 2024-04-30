class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true
      t.date :estimated_date
      t.integer :number_of_guests
      t.string :details
      t.string :code
      t.string :address
      t.integer :status, default: 0
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
