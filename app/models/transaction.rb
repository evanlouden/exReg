class Transaction < ApplicationRecord
  include ApplicationHelper
  belongs_to :family
  belongs_to :admin
  has_many :debits
  has_many :credits
  validates :amount, presence: true, numericality: true
  validates :type, presence: true
end
