module ApplicationHelper
  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_contact
    current_account.contacts.select { |c| c.primary }.first
  end
end
