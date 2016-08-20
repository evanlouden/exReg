class Teacher < Account
  include ApplicationHelper
  has_many :contacts
  has_many :availabilities, autosave: true
  has_many :lessons
  has_many :students, through: :lessons
  has_many :teacher_instruments
  has_many :instruments, through: :teacher_instruments
  before_destroy :destroy_availabilities
  before_destroy :destroy_lessons

  validates :email, uniqueness: true, presence: true, format: { with: /@/ }
  validates :address, presence: true
  validates :city, presence: true, format: { with: /\A[a-zA-Z]+\z/,
    message: "can only be letters" }
  validates :zip, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
  validate :no_availability?

  def earliest_start_time
    array = availabilities.select { |a| a.start_time if a.start_time }
    array.sort! { |a, b| a.start_time <=> b.start_time }
    array.first.start_time
  end

  def latest_end_time
    array = availabilities.select { |a| a.end_time if a.end_time }
    array.sort! { |a, b| b.end_time <=> a.end_time }
    array.first.end_time
  end

  private

  def destroy_availabilities
    availabilities.destroy_all
  end

  def destroy_lessons
    lessons.destroy_all
  end

  def no_availability?
    availabilities.each do |a|
      return false if a.checked == "1"
    end
    errors.add(:availability, "Please select at least one day of availability")
  end
end
