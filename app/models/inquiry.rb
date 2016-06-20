class Inquiry < ApplicationRecord
  has_many :availabilities
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
      if a.checked == "1"
        return false
      end
    end
    errors.add(:availability, "Please select at least one day of availability")
  end

  def destroy_availabilities
    self.availabilities.destroy_all
  end
end
