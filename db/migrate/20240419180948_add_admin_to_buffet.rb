class AddAdminToBuffet < ActiveRecord::Migration[7.1]
  def change
    add_reference :buffets, :admin, null: false, foreign_key: true
  end
end
