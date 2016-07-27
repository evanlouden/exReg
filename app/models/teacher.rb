class Teacher < Account
  include ApplicationHelper
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

  def self.earliest_start_time
    find_each do |teacher|
      @all_start_times = teacher.availabilities.select { |a| a.start_time if a.start_time }
    end
    @all_start_times.sort! { |a, b| a.start_time <=> b.start_time }
    @all_start_times.first.start_time
  end

  def self.latest_end_time
    find_each do |teacher|
      @all_end_times = teacher.availabilities.select { |a| a.end_time if a.end_time }
    end
    @all_end_times.sort! { |a, b| b.end_time <=> a.end_time }
    @all_end_times.first.end_time
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
