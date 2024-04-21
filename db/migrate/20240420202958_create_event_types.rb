class CreateEventTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :event_types do |t|
      t.string :name
      t.string :description
      t.integer :min_guests
      t.integer :max_guests
      t.integer :default_duration
      t.string :menu
      t.boolean :offer_drinks
      t.boolean :offer_decoration
      t.boolean :offer_parking_service
      t.integer :default_address
      t.decimal :min_value, precision: 10, scale: 2
      t.decimal :additional_per_guest, precision: 10, scale: 2
      t.decimal :extra_hour_value, precision: 10, scale: 2
      t.decimal :weekend_min_value, precision: 10, scale: 2
      t.decimal :weekend_additional_per_guest, precision: 10, scale: 2
      t.decimal :weekend_extra_hour_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
