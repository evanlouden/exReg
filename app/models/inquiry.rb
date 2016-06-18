class Inquiry < ApplicationRecord
  has_many :availabilities
  belongs_to :student, optional: true
  accepts_nested_attributes_for :availabilities
  validates_associated :availabilities, on: :save
  validates_associated :student

  validates :instrument, presence: true
end
