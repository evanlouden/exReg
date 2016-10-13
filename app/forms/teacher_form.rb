class TeacherForm
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

  def initialize(id = {})
    if !id["id"].nil?
      @teacher = Teacher.find(id["id"])
      @contact = @teacher.contacts.first
      @availabilities = @teacher.availabilities
    else
      super(id)
    end
  end

  def register
    create_teacher
    create_contact
    create_availabilities
  end

  def persist
    register
    teacher.save!
  end

  def update_teacher(params)
    @availabilities.each do |a|
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
    errors = teacher.errors.full_messages + contact.errors.full_messages
    errors.delete_if { |e| e.include? "invalid" }
    errors.join(", ")
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
    @password = Devise.friendly_token(10)
    @teacher.password = @password
    @teacher.teacher = true
    @teacher.skip_confirmation!
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
    @availabilities = []
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    days.each do |day|
      @availabilities << @teacher.availabilities.build(
        day: send("#{day}_day"),
  	    checked: send("#{day}_checked"),
  		  start_time: send("#{day}_start_time"),
        end_time: send("#{day}_end_time"),
      )
    end
  end
end
