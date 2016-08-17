class TeacherForm
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
    :sunday_day,
    :sunday_checked,
    :sunday_start_time,
    :sunday_end_time,
    :monday_day,
    :monday_checked,
    :monday_start_time,
    :monday_end_time,
    :tuesday_day,
    :tuesday_checked,
    :tuesday_start_time,
    :tuesday_end_time,
    :wednesday_day,
    :wednesday_checked,
    :wednesday_start_time,
    :wednesday_end_time,
    :thursday_day,
    :thursday_checked,
    :thursday_start_time,
    :thursday_end_time,
    :friday_day,
    :friday_checked,
    :friday_start_time,
    :friday_end_time,
    :saturday_day,
    :saturday_checked,
    :saturday_start_time,
    :saturday_end_time,
    :teacher,
    :contact,
    :availabilities
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
      create_teacher
      create_contact
      create_availabilities
    end
  end

  def teacher
    @teacher
  end

  def contact
    @contact
  end

  def availabilities
    @avails
  end

  def save
    register
    teacher.save!
    contact.save!
    availabilities.each do |a|
      a.save!
    end
  end

  def print_errors
    errors = ""
    errors += teacher.errors.full_messages.join(", ")
    errors += contact.errors.full_messages.join(", ")
    availabilities.each do |a|
      unless a.errors.full_messages.empty?
        errors += a.errors.full_messages.join(",")
      end
    end
    errors
  end

  private

  def create_teacher
		@teacher = Teacher.new(
      email: email,
	    address: address,
		  city: city,
		  state: state,
		  zip: zip
    )
    password = Devise.friendly_token(10)
    @teacher.password = password
    @teacher.teacher = true
  end

  def create_contact
    @contact = @teacher.contacts.build(
      first_name: first_name,
      last_name: last_name,
      phone: phone
    )
    @contact.email = @teacher.email
	end

  def create_availabilities
    @avails = []
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    days.each do |day|
      object = @teacher.availabilities.build(
        day: send("#{day}_day"),
  	    checked: send("#{day}_checked"),
  		  start_time: send("#{day}_start_time"),
        end_time: send("#{day}_end_time"),
      )
      @avails << instance_variable_set("@#{day}", object)
    end
  end
end
