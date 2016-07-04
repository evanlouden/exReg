class Family < Account
  has_many :students
  has_many :contacts
  accepts_nested_attributes_for :contacts
end
