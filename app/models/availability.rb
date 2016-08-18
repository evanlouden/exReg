class Availability < ApplicationRecord
  include ApplicationHelper
  belongs_to :student, optional: true
  belongs_to :teacher, optional: true

  DAYS = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ].freeze

  validate :min_time?
  validates :start_time, presence: true, if: :checked?
  validates :end_time, presence: true, if: :checked?
  validates :checked, inclusion: { in: ["0", "1"] }

  private

  def checked?
    checked == "1"
  end

  def min_time?
    return if end_time.blank? || start_time.blank?

    errors.add(:availability, " must be at least 30 minutes") if (end_time - start_time) / 60 < 30 && checked == "1"
  end
end
