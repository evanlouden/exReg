class Student < ApplicationRecord
  include ApplicationHelper
  include PgSearch
  belongs_to :family
  has_many :inquiries
  has_many :lessons
  has_many :teachers, through: :lessons
  has_many :availabilities, autosave: true
  has_many :contacts, through: :family
  before_destroy :destroy_availabilities
  before_destroy :destroy_inquiries

  validates :first_name,
            presence: true
  validates :last_name,
            presence: true
  validates :dob,
            presence: true
  validate :no_availability?

  pg_search_scope :student_search,
                  against: [:first_name, :last_name],
                  associated_against: {
                    family: [:address, :email]
                  }, using: { tsearch: { prefix: true } }

  scope :search, -> (query) { student_search(query) if query.present? }

  def pending_inquiries
    inquiries.where(completed: false) 
  end

  private

  def destroy_availabilities
    availabilities.destroy_all
  end

  def destroy_inquiries
    inquiries.destroy_all
  end

  def no_availability?
    availabilities.each do |a|
      return false if a.checked == "1"
    end
    errors.add(:availability, "Please select at least one day of availability")
  end
end
