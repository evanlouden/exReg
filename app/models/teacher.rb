class Teacher < Account
  has_many :lessons
  has_many :availabilities
  accepts_nested_attributes_for :availabilities
  before_destroy :destroy_availabilities

  validates_associated :availabilities, unless: :admin?
  validate :no_availability?, unless: :admin?

  private

  def admin?
    self.type == "Admin"
  end

  def no_availability?
    availabilities.each do |a|
      return false if a.checked == "1"
    end
    errors.add(:availability, "Please select at least one day of availability")
  end

  def destroy_availabilities
    availabilities.destroy_all
  end
end
