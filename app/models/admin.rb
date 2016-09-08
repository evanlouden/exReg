class Admin < Account
  include ApplicationHelper
  has_many :contacts
  has_many :transactions
  has_many :credits, through: :transactions
  has_many :debits, through: :transactions
end
