class Inquiry < ApplicationRecord
  has_many :availabilities
  has_many :lessons
  belongs_to :student, optional: true
  accepts_nested_attributes_for :availabilities
  before_destroy :destroy_availabilities

  validates_associated :availabilities, on: :save
  validates_associated :student
  validates :instrument, presence: true
  validate :no_availability?

  private

  def no_availability?
    self.availabilities.each do |a|
      return false if a.checked == "1"
    end
    errors.add(:availability, "Please select at least one day of availability")
  end

  def destroy_availabilities
    self.availabilities.destroy_all
  end
end
