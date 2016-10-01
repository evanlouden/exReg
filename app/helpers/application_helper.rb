module ApplicationHelper
  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_family_contact
    contacts.select(&:primary).first
  end

  def staff_name
    contacts.first.full_name
  end

  def balance_sign
    type == "Debit" ? "-" : "+"
  end
end
