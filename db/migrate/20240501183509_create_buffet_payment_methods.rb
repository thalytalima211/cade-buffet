class CreateBuffetPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :buffet_payment_methods do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
