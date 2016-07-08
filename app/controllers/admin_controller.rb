class AdminController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @open_inquiries = Inquiry.all.where(completed: false).order(created_at: :asc)
    @students = Student.all
  end

  def new
    @account = Admin.new
    @contact = @account.contacts.build
  end

  def create
    @account = Admin.new(admin_params)
    @account.contacts.last.email = @account.email
    password = Devise.friendly_token(10)
    @account.password = password
    if @account.save
      flash[:notice] = "Account created #{password}"
      redirect_to admin_index_path
    else
      flash[:error] = @account.errors.full_messages.join(", ")
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
      contacts_attributes: [:id, :first_name, :last_name, :email, :phone]
    ).merge(admin: true)
  end
end
