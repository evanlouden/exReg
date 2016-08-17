class AdminController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @open_inquiries = Inquiry.all.where(completed: false).order(created_at: :asc)
    @students = Student.all
    @teachers = Teacher.all
  end

  def new
    @states = Account::STATES
    @admin = AdminForm.new
  end

  def create
    @states = Account::STATES
    @admin = AdminForm.new(admin_params)
	  @admin.save
    flash[:notice] = "Account created"
    redirect_to admin_index_path
  rescue => e
    flash[:error] = @admin.print_errors
    render :new
  end

  def change
    @teacher = Teacher.find(params[:id])
    @teacher.admin ? @teacher.update_attribute(:admin, false) : @teacher.update_attribute(:admin, true)
    redirect_to teachers_path
  end

  def search
    @students = Student.search(params[:query])
    if @students.empty?
      flash[:error] = "Sorry, but we couldn't find anything matching '#{params[:query]}'"
    end
    render :search
  end

  private

  def admin_params
    params.require(:admin_form).permit(
      :email,
      :remember_me,
      :address,
      :city,
      :state,
      :zip,
      :first_name,
      :last_name,
      :phone,
    )
  end
  # def admin_params
  #   params.require(:admin).permit(
  #     :email,
  #     :password,
  #     :password_confirmation,
  #     :remember_me,
  #     :address,
  #     :city,
  #     :state,
  #     :zip,
  #     contacts_attributes: [:id, :first_name, :last_name, :email, :phone, :primary]
  #   ).merge(admin: true)
  # end
end
