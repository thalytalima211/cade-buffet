class RemoveBuffetFromPhoto < ActiveRecord::Migration[7.1]
  def change
    remove_reference :photos, :buffet, null: false, foreign_key: true
  end
end
