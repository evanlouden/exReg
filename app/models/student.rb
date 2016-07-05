class Student < ApplicationRecord
  include ApplicationHelper
  belongs_to :family
  has_many :inquiries
  has_many :lessons
  has_many :availabilities
  accepts_nested_attributes_for :inquiries
  accepts_nested_attributes_for :availabilities
  before_destroy :destroy_availabilities
  before_destroy :destroy_inquiries

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
  validates_associated :availabilities, on: :save
  validate :no_availability?

  private

  def no_availability?
    availabilities.each do |a|
      return false if a.checked == "1"
    end
    errors.add(:availability, "Please select at least one day of availability")
  end

  def destroy_inquiries
    inquiries.destroy_all
  end

  def destroy_availabilities
    availabilities.destroy_all
  end

end
