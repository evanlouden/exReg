class StudentForm
  include Virtus.model
  include ActiveModel::Model

  attr_accessor \
    :first_name,
    :last_name,
    :dob,
    :instrument,
    :notes,
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
    :student,
    :inquiry,
    :availabilities

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :dob, presence: true

  def initialize(id = {})
    if !id["id"].nil?
      @student = Student.find(id["id"])
      @inquiries = @student.inquiries
      @avails = @student.availabilities
    else
      super(id)
    end
  end

  def register
    if valid?
      create_student
      create_inquiry
      create_availabilities
    end
  end

  def student
    @student
  end

  def inquiries
    @inquiries
  end

  def availabilities
    @avails
  end

  def persist
    register
    student.save!
  end

  def update_student(params)
    @avails.each do |a|
      a.assign_attributes(
        {
          checked: params["#{a.day.downcase}_checked"],
          start_time: params["#{a.day.downcase}_start_time"],
          end_time: params["#{a.day.downcase}_end_time"]
        }
      )
    end
    student.save!
  end

  def print_errors
    errors = ""
    errors += self.errors.full_messages.join(", ")
    if student
      errors += student.errors.full_messages.join(", ")
      inquiries.each do |i|
        errors += i.errors.full_messages.join(",")
      end
      availabilities.each do |a|
        errors += a.errors.full_messages.join(",")
      end
    end
    errors
  end

  private

  def create_student
		@student = Student.new(
      first_name: first_name,
	    last_name: last_name,
		  dob: dob
    )
  end

  def create_inquiry
    @inquiries = []
    @inquiry = @student.inquiries.build(
      instrument: instrument,
      notes: notes
    )
    @inquiries << @inquiry
	end

  def create_availabilities
    @avails = []
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    days.each do |day|
      object = @student.availabilities.build(
        day: send("#{day}_day"),
  	    checked: send("#{day}_checked"),
  		  start_time: send("#{day}_start_time"),
        end_time: send("#{day}_end_time"),
      )
      @avails << instance_variable_set("@#{day}", object)
    end
  end
end
