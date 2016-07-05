class Admin < Account
  has_many :contacts
  accepts_nested_attributes_for :contacts
end
