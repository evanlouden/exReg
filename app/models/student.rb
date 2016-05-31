class Student < ActiveRecord::Base
  belongs_to :account

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :account_id, presence: true
end
