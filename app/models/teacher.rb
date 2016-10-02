class Teacher < Account
  include ApplicationHelper
  include AvailsHelper
  has_many :contacts
  has_many :availabilities, autosave: true
  has_many :lessons
  has_many :students, through: :lessons
  has_many :teacher_instruments
  has_many :instruments, through: :teacher_instruments
  before_destroy :destroy_availabilities
  before_destroy :destroy_lessons

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

  def active_lessons
    lessons.select { |l| l.remaining > 0 }
  end

  def active_students
    students = []
    active_lessons.map { |l| students << l.student.full_name }
    students
  end

  def outstanding_attendance
    active_lessons.select(&:attendance_needed?)
  end

  def calendar_json(inquiry_id = nil)
    {
      time: earliest_start_time,
      endTime: latest_end_time,
      lessons: active_lessons,
      students: active_students,
      availability: avails_hash(availabilities),
      lessonsRemaining: active_lessons.map(&:remaining),
      studentAvail: avails_hash(inquiry_id)
    }
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
