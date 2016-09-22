class AdjustedLesson < ApplicationRecord
  belongs_to :lesson

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }
  validates :effective_date,
            presence: true
  validates :reason,
            presence: true
end
