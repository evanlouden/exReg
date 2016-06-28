class CreateAvailability < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.string :checked, null: false
      t.string :day, null: false
      t.time :start_time
      t.time :end_time
      t.belongs_to :account
      t.belongs_to :student
    end
  end
end
