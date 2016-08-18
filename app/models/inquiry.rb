class Inquiry < ApplicationRecord
  has_many :lessons
  belongs_to :student, optional: true

  validates :instrument, presence: true
end
