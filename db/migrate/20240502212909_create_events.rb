class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.date :expiration_date
      t.decimal :surcharge, precision: 10, scale: 2
      t.decimal :discount, precision: 10, scale: 2
      t.string :description
      t.decimal :default_value, precision: 10, scale: 2
      t.decimal :final_value, precision: 10, scale: 2
      t.references :payment_method, null: false, foreign_key: true
      t.integer :status, default: 0
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
