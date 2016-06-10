class Inquiry < ActiveRecord::Base
  belongs_to :student, optional: true
  has_many :availabilities
  accepts_nested_attributes_for :availabilities
  validates_associated :availabilities

  validates :instrument, presence: {message: "cannot be blank"}
end
