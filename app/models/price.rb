class Price < ApplicationRecord
  validates :tier_name, presence: true
  validates :duration, presence: true, numericality: { greater_than: 4 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def description
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
  end
end
