class Lesson < ApplicationRecord
  include ApplicationHelper
  belongs_to :student
  belongs_to :teacher
  belongs_to :inquiry
  has_many :missed_lessons

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
    purchased - attended
  end

  def remaining_balance
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
    while count <= attended
      date = (start_date + (count * 7)).strftime("%m/%d/%y")
      missed_lesson = missed_lessons.select { |l| l.date == start_date + (count * 7) }
      if missed_lesson.empty?
        history += "<li>#{date} - Attended</li>"
      else
        history += "<li>#{date} - Missed, #{missed_lesson.first.reason.reason}</li>"
      end
      count += 1
    end
    history += "</ul>"
    history.html_safe
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
    if (attended.zero? && Date.today >= active_lesson) || Date.today >= active_lesson
      true
    else
      false
    end
  end
end
