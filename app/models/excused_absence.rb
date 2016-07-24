class ExcusedAbsence < ApplicationRecord
  validates :count, presence: true, numericality: true
end
