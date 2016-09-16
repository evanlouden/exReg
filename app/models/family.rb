class Family < Account
  include ApplicationHelper
  has_many :students
  has_many :contacts
  has_many :transactions
  has_many :credits, through: :transactions
  has_many :debits, through: :transactions
  accepts_nested_attributes_for :contacts

  def current_balance
    all_debits - all_credits
  end

  def all_debits
    debits = transactions.select { |t| t.type == "Debit" }
    debits.map { |t| t.amount.to_f }.reduce(:+) || 0
  end

  def all_credits
    credits = transactions.select { |t| t.type == "Credit" }
    credits.map { |t| t.amount.to_f }.reduce(:+) || 0
  end
end
