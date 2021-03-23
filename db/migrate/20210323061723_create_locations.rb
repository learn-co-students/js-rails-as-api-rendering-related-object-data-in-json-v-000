class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :latitude
      t.string :float
      t.string :longitude
      t.string :float

      t.timestamps
    end
  end
end
