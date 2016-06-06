class StudentsController < ApplicationController
  before_action :authenticate_account!

  def new
    @student = Student.new
    @inquiry = @student.inquiries.build
    @days = Availability::DAYS
    @days.each do |item|
      @inquiry.availabilities.build(day: item)
    end
    @availabilities = @student.inquiries.last.availabilities
  end

  def create
    @student = Student.new(student_params)
    @days = Availability::DAYS
    @availabilities = @student.inquiries.last.availabilities
    @availabilities.each do |day|
      if day.checked == "0"
        day.delete
      end
    end
    if @student.save
      flash[:notice] = "Inquiry Submitted"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @student.errors.full_messages.join(". ")
      render :new
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :dob,
      inquiries_attributes: [:instrument, :student_id,
        availabilities_attributes: [:checked, :day, :start, :end]]
    ).merge(account_id: current_account.id)
  end
end
