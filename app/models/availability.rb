class Availability < ActiveRecord::Base
  belongs_to :inquiry, optional: true

  DAYS = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ].freeze

  validates :start, presence: true
  validates :end, presence: true
  validates :checked, inclusion: { in: ["0", "1"] }
end
