class Lesson < ApplicationRecord
  belongs_to :student
  belongs_to :account

  validates :day, null: false
  validates :start_date, null: false
  validates :start_time, null: false
  validates :duration, null: false, numericality: { greater_than: 4 }
  validates :purchased, null: false
  validates :attended, null: false
  validates :instrument, null: false
  validates :tier_name, null: false
  validates :price, null: false, numericality: { greater_than: 0 }
  validates :student_id, null: false
  validates :account_id, null: false
end
