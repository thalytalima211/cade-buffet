class RemoveDefaultValueFromEvent < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :default_value, :decimal, precision: 10, scale: 2
    add_column :orders, :default_value, :decimal, precision: 10, scale: 2
  end
end
