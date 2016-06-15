class StudentsController < HelperController
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
    checkbox_verify(@availabilities)
    # @availabilities.each do |item|
    #   if item.checked == "0" || item.invalid_time?
    #     item.destroy
    #   end
    # end
    if @student.save
      flash[:notice] = "Inquiry Submitted"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @student.errors.full_messages.join(". ")
      render new_student_path
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :dob,
      inquiries_attributes: [:instrument, :student_id, :notes,
        availabilities_attributes: [:checked, :day, :start, :end]]
    ).merge(account_id: current_account.id)
  end
end
