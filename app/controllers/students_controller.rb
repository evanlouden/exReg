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
    if @student.save
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
    if @student.update(student_params)
      flash[:notice] = "Inquiry Updated"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @student.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    if !current_account.students.include?(@student)
      flash[:notice] = 'You are not authorized to delete this student'
      redirect_to dashboard_index_path and return
    else
      @student.destroy
      flash[:notice] = "Student and inquiry deleted"
      redirect_to dashboard_index_path
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
