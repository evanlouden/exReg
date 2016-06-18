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
    @availabilities = @student.inquiries.last.availabilities
    if any_selected?(@availabilities) && @student.valid?
      flash[:alert] = "Please select at least one day of availability"
      render :new
    elsif @student.save
      flash[:notice] = "Inquiry Submitted"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @student.errors.full_messages.join(", ")
      render new_student_path
    end
  end

  def edit
    @student = Student.find(params[:id])
    @availabilities = @student.inquiries.last.availabilities
  end

  def update
    @student = Student.find(params[:id])
    @availabilities = @student.inquiries.last.availabilities
    if any_selected?(@availabilities) && @student.valid?
      flash[:alert] = "Please select at least one day of availability"
      render :edit
    elsif @student.update(student_params)
      flash[:notice] = "Inquiry Updated"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @student.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :dob,
      inquiries_attributes: [:id, :instrument, :student_id, :notes,
        availabilities_attributes: [:id, :checked, :day, :start_time, :end_time]]
    ).merge(account_id: current_account.id)
  end
end
