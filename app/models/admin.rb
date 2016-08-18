class Admin < Account
  include ApplicationHelper
  has_many :contacts

  validates :email, uniqueness: true, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zip, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
end
