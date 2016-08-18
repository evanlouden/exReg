class Contact < ApplicationRecord
  include ApplicationHelper
  belongs_to :family, optional: true
  belongs_to :teacher, optional: true
  belongs_to :admin, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true, numericality: true, length: { is: 10 }
end
