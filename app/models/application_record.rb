class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
