class RemoveEventTypeFromEvent < ActiveRecord::Migration[7.1]
  def change
    remove_reference :events, :event_type, null: false, foreign_key: true
  end
end
