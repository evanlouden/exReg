class CreateAvailability < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.string :day, null: false
      t.string :start, null: false
      t.string :end, null: false
      t.belongs_to :inquiry, null: false
    end
  end
end
