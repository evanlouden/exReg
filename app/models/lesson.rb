class Lesson < ApplicationRecord
  include ApplicationHelper
  belongs_to :student
  belongs_to :teacher
  belongs_to :inquiry
  has_many :missed_lessons
  has_many :dropped_lessons

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
    purchased - (attended + dropped_count)
  end

  def dropped_count
    dropped_lessons.map(&:amount).inject(0, &:+)
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

  def future_lessons
    lessons = []
    remaining.times { |i| lessons << active_lesson + (7 * i) }
    lessons
  end

  def iterative_lesson(count)
    start_date + (count * 7)
  end

  def lesson_date(count)
    iterative_lesson(count).strftime("%m/%d/%y")
  end

  def missed_lesson(count)
    missed_lessons.select { |l| l.date == iterative_lesson(count) }
  end

  def dropped_lesson(count)
    dropped_lessons.select do |l|
      if l.effective_date == iterative_lesson(count)
        true
      elsif l.effective_date < iterative_lesson(count) &&
            l.effective_date + ((l.amount - 1) * 7) >= iterative_lesson(count)
        true
      else
        false
      end
    end
  end

  def format_date_li(count)
    li = "<li>#{lesson_date(count)}"
    li += if missed_lesson(count).empty? && dropped_lesson(count).empty?
            " - Attended</li>"
          elsif !dropped_lesson(count).empty?
            " - Dropped, #{dropped_lesson(count).first.reason}</li>"
          else
            " - Missed, #{missed_lesson(count).first.reason.reason}</li>"
          end
    li
  end

  def all_logged_lessons
    attended + dropped_count + excused_counter
  end

  def print_each_line(count, history)
    while !attended.zero? && count < (all_logged_lessons)
      history += format_date_li(count)
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
    start_date + ((all_logged_lessons) * 7)
  end

  def attendance_needed?
    Date.today >= active_lesson
  end

  def self.all_active_lessons
    lessons = select { |l| l.remaining.positive? }
    lessons.sort_by! { |l| [l.teacher.contacts.first.last_name, l.student.last_name] }
  end
end
