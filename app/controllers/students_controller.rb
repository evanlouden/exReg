class StudentsController < ApplicationController
  before_action :authenticate_account!

  def new
    @student = Student.new
    @inquiry = @student.inquiries.build
    7.times { @inquiry.availabilities.build }
    @availabilities = @student.inquiries.last.availabilities
    @days = Availability::DAYS
  end

  def create
    @days = Availability::DAYS
    @student = Student.new(student_params)
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
        availabilities_attributes: [:day, :start, :end]]
    ).merge(account_id: current_account.id)
  end
end
