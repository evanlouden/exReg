class StudentsController < PermissionsController
  before_action :authenticate_account!

  def index
    @students = current_account.students
  end

  def new
    @current_account = current_account
    @days = Availability::DAYS
    @instruments = Instrument.all
    @student_form = StudentForm.new
  end

  def create
    @current_account = current_account
    @days = Availability::DAYS
    @instruments = Instrument.all
    @student_form = StudentForm.new(student_params)
    @student_form.persist
    clear_times(@student_form.student.availabilities)
    @student_form.student.family = @current_account
    @student_form.student.save
    flash[:notice] = "Student Created, Inquiry Submitted"
    redirect_to dashboard_index_path
  rescue => e
    flash[:error] = @student_form.print_errors
    render :new
  end

  def show
    @student = Student.find(params[:id])
    @inquiries = @student.pending_inquiries
    @lessons = @student.lessons
  end

  def edit
    @days = Availability::DAYS
    @student_form = StudentForm.new(params)
    @student = @student_form.student
    @availabilities = sort_avails(@student_form.availabilities)
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @availabilities.select { |a| a.checked == "1" } }
    end
  end

  def update
    @days = Availability::DAYS
    @student_form = StudentForm.new(params)
    @student = @student_form.student
    @availabilities = sort_avails(@student.availabilities)
    @student_form.update_student(student_params)
    clear_times(@student.availabilities)
    flash[:notice] = "Availability Updated"
    redirect_to dashboard_index_path
  rescue => e
    flash[:error] = @student_form.print_errors
    render :edit
  end

  private

  def student_params
    params.require(:student_form).permit(
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
    :saturday_end_time
  )
  end
end
