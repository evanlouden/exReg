class Account < ApplicationRecord
  has_many :students
  has_many :contacts
  accepts_nested_attributes_for :contacts
  # has_many :availabilities
  # accepts_nested_attributes_for :availabilities
  # before_destroy :destroy_availabilities
  before_destroy :destroy_contacts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: true, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zip, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true
  # validates_associated :availabilities, unless: :admin?
  # validate :no_availability?, unless: :admin?

  private

  def destroy_contacts
    contacts.destroy_all
  end
end
