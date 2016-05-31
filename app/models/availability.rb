class Availability < ActiveRecord::Base
  belongs_to :inquiry

  DAYS = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
    ].freeze

  validates :inquiry_id, presence: true
  validates :day, presence: true
  validates :start, presence: true
  validates :end, presence: true
end
