class AdminForm
  include Virtus.model
  include ActiveModel::Model

  attr_accessor \
    :email,
    :address,
    :city,
    :state,
    :zip,
    :first_name,
    :last_name,
    :phone,
    :admin,
    :contact

	validates :email, presence: true
	validates :address, presence: true
  validates :city, presence: true
	validates :state, presence: true
	validates :zip, presence: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :phone, presence: true

  def initialize(id = {})
    if !id["id"].nil?
      @admin = Admin.find(id["id"])
      @contact = @teacher.contacts.first
    else
      super(id)
    end
  end

  def register
    if valid?
      create_admin
      create_contact
    end
  end

  def persist
    register
    admin.save!
  end

  def print_errors
    errors = ""
    if admin
      errors += contact.errors.full_messages.join(", ")
      errors += ", "
      errors += admin.errors.full_messages.join(", ")
    else
      errors += self.errors.full_messages.join(", ")
    end
  end

  private

  def create_admin
		@admin = Admin.new(
      email: email,
	    address: address,
		  city: city,
		  state: state,
		  zip: zip,
      admin: true
    )
    password = Devise.friendly_token(10)
    @admin.password = password
  end

  def create_contact
    @contact = @admin.contacts.build(
      first_name: first_name,
      last_name: last_name,
      phone: phone,
      primary: true
    )
    @contact.email = @admin.email
	end
end
