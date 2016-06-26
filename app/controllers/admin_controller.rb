class AdminController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @teachers = Account.where(teacher: true).order(email: :desc)
    @admins = Account.where(admin: true).order(email: :desc)
    @open_inquiries = Inquiry.all.where(completed: false)
    @students = Student.all
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    password = Devise.friendly_token(10)
    @account.password = password
    if @account.save
      flash[:notice] = "Account created #{password}"
      redirect_to admin_index_path
    else
      flash[:error] = @account.errors.full_messages.join(', ')
      render :new
    end
  end

  def change
    @teacher = Account.find(params[:id])
    @teacher.admin ? @teacher.update_attribute(:admin, false) : @teacher.update_attribute(:admin, true)
    redirect_to admin_index_path
  end

  def complete
    @inquiry = Inquiry.find(params[:id])
    @inquiry.update_attribute(:completed, true)
    flash[:notice] = "Inquiry marked as completed"
    redirect_to admin_index_path
  end

  private

  def account_params
    params.require(:account).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :address,
      :city,
      :state,
      :zip,
      :admin,
      :teacher
    )
  end
end
