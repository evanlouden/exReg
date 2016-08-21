class Reason < ApplicationRecord
  has_many :missed_lessons

  validates :reason,
            presence: true
end
