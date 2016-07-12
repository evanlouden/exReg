class Lesson < ApplicationRecord
  belongs_to :student
  belongs_to :teacher
  belongs_to :inquiry
  has_many :missed_lessons

  validates :day, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true, numericality: { greater_than: 4 }
  validates :purchased, presence: true
  validates :attended, presence: true
  validates :instrument, presence: true
  validates :tier_name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :student, presence: true
  validates :teacher, presence: true
  validates :inquiry, presence: true

  def remaining
    purchased - attended
  end

  def remaining_balance
    price * purchased
  end

  def time_info
    "#{day}s, #{start_time.strftime("%l:%M %p")}"
  end

  def price_info
    "#{tier_name}: #{duration} min., $#{'%.2f' % price}"
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
    if attended == 0 && Date.today >= start_date && Date.today >= active_lesson
      true
    elsif Date.today >= active_lesson
      true
    else
      false
    end
  end
end
