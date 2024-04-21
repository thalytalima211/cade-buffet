class AddBuffetToEventType < ActiveRecord::Migration[7.1]
  def change
    add_reference :event_types, :buffet, null: false, foreign_key: true
  end
end
