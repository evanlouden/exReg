class StudentForm
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
    :inquiries,
    :availabilities

  def initialize(id = {})
    if !id["id"].nil?
      @student = Student.find(id["id"])
      @inquiries = @student.inquiries
      @availabilities = @student.availabilities
    else
      super(id)
    end
  end

  def register
    create_student
    create_inquiry
    create_availabilities
  end

  def persist
    register
    student.save!
  end

  def update_student(params)
    @availabilities.each do |a|
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
    errors = student.errors.full_messages + inquiries.last.errors.full_messages
    errors.delete_if { |e| e.include? "invalid" }
    errors.join(", ")
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
    @availabilities = []
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    days.each do |day|
      @availabilities << @student.availabilities.build(
        day: send("#{day}_day"),
  	    checked: send("#{day}_checked"),
  		  start_time: send("#{day}_start_time"),
        end_time: send("#{day}_end_time"),
      )
    end
  end
end
