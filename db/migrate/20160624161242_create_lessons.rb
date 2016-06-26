class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :day, null: false
      t.date :start_date, null: false
      t.time :start_time, null: false
      t.integer :duration, null: false
      t.integer :purchased, null: false
      t.integer :attended, null: false, default: 0
      t.string :instrument, null: false
      t.string :tier_name, null: false
      t.integer :price, null: false
      t.belongs_to :student, null: false
      t.belongs_to :account, null: false
      t.belongs_to :inquiry, null: false
    end
  end
end
