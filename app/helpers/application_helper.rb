module ApplicationHelper
  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_contact
    current_account.contacts.select(&:primary).first
  end

  def staff_name
    contacts.first.full_name
  end
end
