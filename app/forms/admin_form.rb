class AdminForm
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

  def initialize(id = {})
    if !id["id"].nil?
      @admin = Admin.find(id["id"])
      @contact = @teacher.contacts.first
    else
      super(id)
    end
  end

  def register
    create_admin
    create_contact
  end

  def persist
    register
    admin.save!
  end

  def print_errors
    errors = admin.errors.full_messages + contact.errors.full_messages
    errors.delete_if { |e| e.include? "invalid" }
    errors.join(", ")
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
    @password = Devise.friendly_token(10)
    @admin.password = @password
    @admin.skip_confirmation!
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
