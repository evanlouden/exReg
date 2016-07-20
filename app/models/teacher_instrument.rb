class TeacherInstrument < ApplicationRecord
  validates_uniqueness_of :instrument_id, scope: :teacher_id

  belongs_to :teacher
  belongs_to :instrument
end
