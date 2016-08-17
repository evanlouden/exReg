class TeachersController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin, only: [:index, :new, :create, :destroy]

  def index
    @teachers = Teacher.all.sort_by { |t| t.contacts.first.last_name }
    @admins = Account.where(admin: true).sort_by { |t| t.contacts.first.last_name }
  end

  def show
    params[:id] ? @teacher = Teacher.find(params[:id]) : @teacher = current_account
    @lessons = @teacher.lessons.select { |l| l.remaining > 0 }
    @students = []
    @lessons.map { |l| @students << l.student.full_name }
    @lessons_remaining = @lessons.map(&:remaining)
    @attendance = @lessons.select { |x| x.attendance_needed? }
    @attendance.each do |lesson|
      lesson.missed_lessons.build
    end
    @time = @teacher.earliest_start_time
    @end_time = @teacher.latest_end_time
    teacher_days = sort_avails(@teacher.availabilities)
    @teacher_avail = {}
    teacher_days.each do |a|
      time_hash = {}
      if a.start_time
        time_hash[:start_time] = a.start_time
      else
        time_hash[:start_time] = nil
      end
      if a.end_time
        time_hash[:end_time] = a.end_time
      else
        time_hash[:end_time] = nil
      end
      @teacher_avail[a.day] = time_hash
    end
    unless params[:inquiry].nil?
      @student = Inquiry.find(params[:inquiry]).student
      student_days = sort_avails(@student.availabilities)
      @student_avail = {}
      student_days.each do |a|
        time_hash = {}
        if a.start_time
          time_hash[:start_time] = a.start_time
        else
          time_hash[:start_time] = nil
        end
        if a.end_time
          time_hash[:end_time] = a.end_time
        else
          time_hash[:end_time] = nil
        end
        @student_avail[a.day] = time_hash
      end
    end
    response = {
      time: @time,
      endTime: @end_time,
      lessons: @lessons,
      students: @students,
      availability: @teacher_avail,
      lessonsRemaining: @lessons_remaining,
      student_avail: @student_avail
    }
    respond_to do |format|
      format.html { render :show }
      format.json { render json: response }
    end
  end

  def new
    @states = Account::STATES
    @days = Availability::DAYS
    @teacher = TeacherForm.new
  end

  def create
    @states = Account::STATES
    @days = Availability::DAYS
    @teacher = TeacherForm.new(teacher_params)
    @teacher.save
    flash[:notice] = "Account created"
    redirect_to admin_index_path
  rescue => e
    flash[:error] = @teacher.print_errors
    render :new
  end

  def edit
    @teacher = Teacher.find(params[:id])
    @availabilities = sort_avails(@teacher.availabilities)
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: @availabilities.select { |a| a.checked == "1" } }
    end
  end

  def update
    @teacher = Teacher.find(params[:id])
    @availabilities = @teacher.availabilities
    if @teacher.update(teacher_params)
      clear_times(@availabilities)
      flash[:notice] = "Availability Updated"
      if current_account.type == "Teacher"
        redirect_to teacher_path(@teacher)
      else
        redirect_to teachers_path
      end
    else
      flash[:alert] = @teacher.errors.full_messages.join(", ")
      render :edit
    end
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
  # def teacher_params
  #   params.require(:teacher).permit(
  #     :email,
  #     :password,
  #     :password_confirmation,
  #     :remember_me,
  #     :address,
  #     :city,
  #     :state,
  #     :zip,
  #     contacts_attributes: [:id, :first_name, :last_name, :email, :phone, :primary],
  #     availabilities_attributes: [:id, :checked, :day, :start_time, :end_time]
  #   ).merge(teacher: true)
  # end
end
