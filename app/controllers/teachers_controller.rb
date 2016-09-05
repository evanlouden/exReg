class TeachersController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin, only: [:index, :new, :create, :destroy]

  def index
    @teachers = Teacher.all.sort_by { |t| t.contacts.first.last_name }
    @admins = Account.where(admin: true).sort_by { |t| t.contacts.first.last_name }
  end

  def show
    params[:id] ? @teacher = Teacher.find(params[:id]) : @teacher = current_account
    @attendance = @teacher.outstanding_attendance
    @attendance.map { |x| x.missed_lessons.build }
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @teacher.calendar_json(params[:inquiry]) }
    end
  end

  def new
    @states = Account::STATES
    @days = Availability::DAYS
    @teacher_form = TeacherForm.new
  end

  def create
    @states = Account::STATES
    @days = Availability::DAYS
    @teacher_form = TeacherForm.new(teacher_params)
    @teacher_form.persist
    clear_times(@teacher_form.teacher.availabilities)
    flash[:notice] = "Account created"
    redirect_to admin_index_path
  rescue => e
    flash[:error] = @teacher_form.print_errors
    render :new
  end

  def edit
    @days = Availability::DAYS
    @teacher_form = TeacherForm.new(params)
    @teacher = @teacher_form.teacher
    @availabilities = sort_avails(@teacher.availabilities)
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @availabilities.select { |a| a.checked == "1" } }
    end
  end

  def update
    @days = Availability::DAYS
    @teacher_form = TeacherForm.new(params)
    @teacher = @teacher_form.teacher
    @availabilities = sort_avails(@teacher.availabilities)
    @teacher_form.update_teacher(teacher_params)
    clear_times(@teacher.availabilities)
    flash[:notice] = "Availability Updated"
    if current_account.type == "Teacher"
      redirect_to teacher_path(@teacher)
    else
      redirect_to teachers_path
    end
  rescue => e
    flash[:error] = @teacher_form.print_errors
    render :edit
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    flash[:notice] = "Teacher deleted"
    redirect_to teachers_path
  end

  private

  def teacher_params
    params.require(:teacher_form).permit(
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
      :saturday_end_time
    )
  end
end
