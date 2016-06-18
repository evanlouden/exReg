class Availability < ApplicationRecord
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

  validate :valid_time?
  validates :start_time, presence: true, if: :checked?
  validates :end_time, presence: true, if: :checked?
  validates :checked, inclusion: { in: ["0", "1"] }

  private

  def checked?
    self.checked == "1"
  end

  def valid_time?
    return if self.end_time.blank? || self.start_time.blank?

    if self.end_time < self.start_time && self.checked == "1"
      errors.add(:end_time, "must be later than start time")
    end
  end
end
