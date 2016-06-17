class CreateAvailability < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.string :checked, null: false
      t.string :day, null: false
      t.time :start
      t.time :end
      t.belongs_to :inquiry, null: false
    end
  end
end
