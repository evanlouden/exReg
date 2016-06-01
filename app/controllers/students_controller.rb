class StudentsController < ApplicationController
  def new
    @student = Student.new
    @inquiry = @student.inquiries.build
    # @contact = Contact.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      flash[:notice] = "Inquiry Submitted"
      redirect_to dwellings_path
    else
      flash[:alert] = @save.errors.full_messages.join(". ")
      render :new
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :dob,
      inquiries_attributes: [:instrument, :student_id]
    ).merge(account_id: current_account.id)
  end
end
