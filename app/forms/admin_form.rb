class AdminForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor(
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
  )

	validates :email, presence: true
	validates :address, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :zip, presence: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :phone, presence: true

  def register
    if valid?
      create_admin
      create_contact
    end
  end

  def admin
    @admin
  end

  def contact
    @contact
  end

  def save
    register
    admin.save!
    contact.save!
  end

  def print_errors
    errors = ""
    errors += @admin.admin.errors.full_messages.join(", ")
    errors += @admin.contact.errors.full_messages.join(", ")
    errors
  end

  private

  def create_admin
		@admin = Admin.new(
      email: email,
	    address: address,
		  city: city,
		  state: state,
		  zip: zip
    )
    password = Devise.friendly_token(10)
    @admin.password = password
    @admin.admin = true
    @admin
  end

  def create_contact
    @contact = @admin.contacts.build(
      first_name: first_name,
      last_name: last_name,
      phone: phone
    )
    @contact.email = @admin.email
    @contact
	end
end
