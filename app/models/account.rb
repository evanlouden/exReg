class Account < ApplicationRecord
  before_destroy :destroy_contacts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: true, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zip, presence: true, numericality: true, length: { is: 5 }
  validates :state, presence: true

  private

  def destroy_contacts
    contacts.destroy_all
  end
end
