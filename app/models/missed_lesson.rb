class MissedLesson < ApplicationRecord
  belongs_to :lesson
  belongs_to :reason

  validates :date,
            presence: true
end
