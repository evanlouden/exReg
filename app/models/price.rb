class Price < ApplicationRecord
  validates :tier_name, null: false
  validates :duration, null: false, numericality: { greater_than: 4 }
  validates :price, null: false, numericality: { greater_than: 0 }

  def description
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
  end
end
