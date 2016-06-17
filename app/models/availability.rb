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
  validates :start, presence: true, if: :checked?
  validates :end, presence: true, if: :checked?
  validates :checked, inclusion: { in: ["0", "1"] }

  private

  def checked?
    self.checked == "1"
  end

  def valid_time?
    return if self.end.blank? || self.start.blank?

    if self.end < self.start
      errors.add(:end, "must be later than start time")
    end
  end
end
