class Student < ApplicationRecord
  belongs_to :account
  has_many :inquiries
  has_many :lessons
  accepts_nested_attributes_for :inquiries
  before_destroy :destroy_inquiries

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :account_id, presence: true

  private

  def destroy_inquiries
    self.inquiries.destroy_all
  end
end
