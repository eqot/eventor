class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title,        null: false
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time,   null: false
      t.string :place,        null: false
      t.string :file
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :events, :owner_id
  end
end
