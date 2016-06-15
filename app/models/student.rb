class Student < ActiveRecord::Base
  belongs_to :account
  has_many :inquiries
  accepts_nested_attributes_for :inquiries

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :account_id, presence: true
end
