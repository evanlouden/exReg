class Price < ApplicationRecord
  validates :tier_name, presence: true
  validates :duration, presence: true, numericality: { greater_than: 4 }
  validate :valid_length?
  validates :price, presence: true, numericality: { greater_than: 0 }

  def description
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
  end

  private

  def valid_length?
    unless duration.nil?
      if duration % 15 != 0
        errors.add(:duration, "must be intervals of 15 minutes")
      elsif duration < 30
        errors.add(:duration, "must be minimum of 30 minutes")
      end
    end
  end
end
