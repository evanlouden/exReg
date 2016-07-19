class Instrument < ApplicationRecord
  has_many :teacher_instruments
  has_many :teachers, through: :teacher_instruments

  validates :name, presence: true
end
