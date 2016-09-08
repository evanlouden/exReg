class Family < Account
  include ApplicationHelper
  has_many :students
  has_many :contacts
  has_many :transactions
  has_many :credits, through: :transactions
  has_many :debits, through: :transactions
  accepts_nested_attributes_for :contacts

  def current_balance
    debits = transactions.select { |t| t.type == "Debit"}
    credits = transactions.select { |t| t.type == "Credit"}
    debits = debits.map { |t| t.amount.to_f }.reduce(:+)
    credits = credits.map { |t| t.amount.to_f }.reduce(:+)
    debits - credits
  end
end
