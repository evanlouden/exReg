class Admin < Account
  include ApplicationHelper
  has_many :contacts
end
