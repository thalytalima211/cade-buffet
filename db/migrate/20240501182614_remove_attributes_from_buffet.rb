class RemoveAttributesFromBuffet < ActiveRecord::Migration[7.1]
  def change
    remove_column :buffets, :accepts_cash, :string
    remove_column :buffets, :accepts_pix, :string
    remove_column :buffets, :accepts_credit_card, :string
  end
end
