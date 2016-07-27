class TeachersController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin, only: [:index, :new, :create, :destroy]

  def index
    @teachers = Teacher.all.sort_by { |t| t.contacts.first.last_name }
    @admins = Account.where(admin: true).sort_by { |t| t.contacts.first.last_name }
  end

  def show
    params[:id] ? @teacher = Teacher.find(params[:id]) : @teacher = current_account
    @lessons = @teacher.lessons
    @students = []
    @lessons.map { |l| @students << l.student.full_name }
    @attendance = @lessons.select { |x| x.attendance_needed? }
    @attendance.each do |lesson|
      lesson.missed_lessons.build
    end
    @time = @teacher.earliest_start_time
    @end_time = @teacher.latest_end_time
    @days = Availability::DAYS
    response = { lessons: @lessons, students: @students }
    respond_to do |format|
      format.html { render :show }
      format.json { render json: response }
    end
  end

  def new
    @states = Account::STATES
    @teacher = Teacher.new
    @contact = @teacher.contacts.build
    @days = Availability::DAYS
    @days.each do |item|
      @teacher.availabilities.build(day: item)
    end
    @availabilities = @teacher.availabilities
  end

  def create
    @states = Account::STATES
    @teacher = Teacher.new(teacher_params)
    @teacher.contacts.last.email = @teacher.email
    @availabilities = @teacher.availabilities
    password = Devise.friendly_token(10)
    @teacher.password = password
    if @teacher.save
      clear_times(@availabilities)
      flash[:notice] = "Account created #{password}"
      redirect_to admin_index_path
    else
      flash[:error] = @teacher.errors.full_messages.join(", ")
      render :new
    end
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
    params.require(:teacher).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :address,
      :city,
      :state,
      :zip,
      contacts_attributes: [:id, :first_name, :last_name, :email, :phone, :primary],
      availabilities_attributes: [:id, :checked, :day, :start_time, :end_time]
    ).merge(teacher: true)
  end
end
