class AdminController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @open_inquiries = Inquiry.all.where(completed: false).order(created_at: :asc)
    @students = Student.all
    @teachers = Teacher.all
    @time = Teacher.earliest_start_time
    @end_time = Teacher.latest_end_time
    @days = Availability::DAYS
  end

  def new
    @states = Account::STATES
    @admin = Admin.new
    @contact = @admin.contacts.build
  end

  def create
    @states = Account::STATES
    @admin = Admin.new(admin_params)
    @admin.contacts.last.email = @admin.email
    password = Devise.friendly_token(10)
    @admin.password = password
    if @admin.save
      flash[:notice] = "Account created #{password}"
      redirect_to admin_index_path
    else
      flash[:error] = @admin.errors.full_messages.join(", ")
      render :new
    end
  end

  def change
    @teacher = Teacher.find(params[:id])
    @teacher.admin ? @teacher.update_attribute(:admin, false) : @teacher.update_attribute(:admin, true)
    redirect_to teachers_path
  end

  private

  def admin_params
    params.require(:admin).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :address,
      :city,
      :state,
      :zip,
      contacts_attributes: [:id, :first_name, :last_name, :email, :phone, :primary]
    ).merge(admin: true)
  end
end
