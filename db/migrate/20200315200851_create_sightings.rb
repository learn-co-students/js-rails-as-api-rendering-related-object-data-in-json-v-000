class CreateSightings < ActiveRecord::Migration[5.2]
  def change
    create_table :sightings do |t|
      t.belongs_to :bird, foreign_key: true
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
