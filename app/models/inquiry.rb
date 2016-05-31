class Inquiry < ActiveRecord::Base
  belongs_to :student
  has_one :instrument

  validates :student_id, presence: true
  validates :instrument_id, presence: true
  validates :dob, presence: true
end
