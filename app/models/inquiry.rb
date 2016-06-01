class Inquiry < ActiveRecord::Base
  belongs_to :student, optional: true

  validates :instrument, presence: true
end
