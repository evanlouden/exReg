class Contact < ApplicationRecord
  belongs_to :account, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
