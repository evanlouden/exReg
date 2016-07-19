class Teacher < Account
  has_many :contacts
  accepts_nested_attributes_for :contacts
  has_many :lessons
  has_many :teacher_instruments
  has_many :instruments, through: :teacher_instruments
  has_many :availabilities
  accepts_nested_attributes_for :availabilities
  before_destroy :destroy_availabilities
  before_destroy :destroy_lessons

  validates_associated :availabilities, unless: :admin?
  validate :no_availability?, unless: :admin?

  def full_name
    "#{contacts.first.first_name} #{contacts.first.last_name}"
  end

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

  def destroy_lessons
    lessons.destroy_all
  end
end
