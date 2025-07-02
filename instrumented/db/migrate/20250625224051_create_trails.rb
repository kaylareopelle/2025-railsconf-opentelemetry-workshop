class CreateTrails < ActiveRecord::Migration[8.0]
  def change
    create_table :trails do |t|
      t.string :name
      t.string :location
      t.integer :length
      t.integer :elevation
      t.text :description

      t.timestamps
    end
  end
end
