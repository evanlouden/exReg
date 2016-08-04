class Price < ApplicationRecord
  validates :tier_name, presence: true
  validate :valid_length?
  validates :duration, presence: true, numericality: { greater_than: 4 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def description
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
  end

  private

  def valid_length?
    if duration && duration % 15 != 0 
      errors.add(:duration, "must be intervals of 15 minutes")
    end
  end
end
