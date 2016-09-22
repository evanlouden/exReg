class Lesson < ApplicationRecord
  include ApplicationHelper
  belongs_to :student
  belongs_to :teacher
  belongs_to :inquiry
  has_many :missed_lessons
  has_many :adjusted_lessons

  validates :day,
            presence: true
  validates :start_date,
            presence: true
  validates :start_time,
            presence: true
  validates :duration,
            presence: true,
            numericality: { greater_than: 4 }
  validates :purchased,
            presence: true
  validates :attended,
            presence: true
  validates :instrument,
            presence: true
  validates :tier_name,
            presence: true
  validates :price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :student,
            presence: true
  validates :teacher,
            presence: true
  validates :inquiry,
            presence: true

  def remaining
    purchased - (attended + adjusted_count)
  end

  def adjusted_count
    adjusted_lessons.map(&:amount).inject(0, &:+)
  end

  def initial_balance
    price * purchased
  end

  def time_info
    "#{day}s, #{start_time.strftime('%l:%M %p')}"
  end

  def price_info
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
  end

  def print_history
    count = 0
    history = "<ul>"
    history = print_each_line(count, history) + "</ul>"
    history.html_safe
  end

  def print_each_line(count, history)
    while !attended.zero? && count < (attended + adjusted_count)
      date = (start_date + (count * 7)).strftime("%m/%d/%y")
      missed_lesson = missed_lessons.select { |l| l.date == start_date + (count * 7) }
      adjusted_lesson = adjusted_lessons.select do |l|
        case
          when l.effective_date == start_date + (count * 7)
            true
          when l.effective_date < start_date + (count * 7) && l.effective_date + ((l.amount - 1) * 7) >= start_date + (count * 7)
            true
          else
            false
          end
      end
      history += if missed_lesson.empty? && adjusted_lesson.empty?
                   "<li>#{date} - Attended</li>"
                 elsif !adjusted_lesson.empty?
                   "<li>#{date} - Credited</li>"
                 else
                   "<li>#{date} - Missed, #{missed_lesson.first.reason.reason}</li>"
                 end
      count += 1
    end
    history
  end

  def excused_counter
    count = 0
    missed_lessons.each do |missed|
      unless missed.reason.nil? || missed.reason.student_charged
        count += 1
      end
    end
    count
  end

  def active_lesson
    start_date + ((attended + excused_counter) * 7)
  end

  def attendance_needed?
    Date.today >= active_lesson
  end

  def self.all_active_lessons
    lessons = select { |l| l.remaining.positive? }
    lessons.sort_by! { |l| [l.teacher.contacts.first.last_name, l.student.last_name] }
  end
end
