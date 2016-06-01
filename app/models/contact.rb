class Contact < ActiveRecord::Base
  belongs_to :account, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :account_id, presence: true
end
