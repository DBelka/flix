class CreateCharacterisations < ActiveRecord::Migration[7.0]
  def change
    create_table :characterisations do |t|
      t.references :genre, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
