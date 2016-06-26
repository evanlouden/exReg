class Lesson < ApplicationRecord
  belongs_to :student
  belongs_to :account
  belongs_to :inquiry

  validates :day, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true, numericality: { greater_than: 4 }
  validates :purchased, presence: true
  validates :attended, presence: true
  validates :instrument, presence: true
  validates :tier_name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :student, presence: true
  validates :account, presence: true
  validates :inquiry, presence: true
end
