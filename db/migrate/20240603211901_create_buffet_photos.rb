class CreateBuffetPhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :buffet_photos do |t|
      t.references :buffet, null: false, foreign_key: true
      t.references :photo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
