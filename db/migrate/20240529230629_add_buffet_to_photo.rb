class AddBuffetToPhoto < ActiveRecord::Migration[7.1]
  def change
    add_reference :photos, :buffet, null: false, foreign_key: true
  end
end
