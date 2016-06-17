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

  # validates :start, presence: true
  # validates :end, presence: true
  validates :checked, inclusion: { in: ["0", "1"] }

  def invalid_time?
    start_time = self.start.gsub(":", "").to_i
    end_time = self.end.gsub(":", "").to_i
    end_time < start_time
  end
end
