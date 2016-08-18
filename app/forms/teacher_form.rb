class TeacherForm
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
      @teacher = Teacher.find(id["id"])
      @contact = @teacher.contacts.first
      @avails = @teacher.availabilities
    else
      super(id)
    end
  end

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

  def persist
    register
    teacher.save!
  end

  def update_teacher(params)
    @avails.each do |a|
      a.assign_attributes(
        {
          checked: params["#{a.day.downcase}_checked"],
          start_time: params["#{a.day.downcase}_start_time"],
          end_time: params["#{a.day.downcase}_end_time"]
        }
      )
    end
    teacher.save!
  end

  def print_errors
    errors = ""
    errors += self.errors.full_messages.join(", ")
    if teacher || contact
      errors += teacher.errors.full_messages.join(", ")
      errors += contact.errors.full_messages.join(", ")
      availabilities.each do |a|
        unless a.errors.full_messages.empty?
          errors += a.errors.full_messages.join(",")
        end
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
