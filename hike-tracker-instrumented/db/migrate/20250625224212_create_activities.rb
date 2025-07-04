class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :user_id
      t.integer :trail_id
      t.boolean :in_progress
      t.string :name

      t.timestamps
    end
  end
end
