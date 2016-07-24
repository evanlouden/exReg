class Admin < Account
  include ApplicationHelper
  has_many :contacts
  accepts_nested_attributes_for :contacts
end
