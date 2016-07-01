class AdminController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @open_inquiries = Inquiry.all.where(completed: false).order(created_at: :asc)
    @students = Student.all
  end

  def new
    @account = Account.new
    @contact = @account.contacts.build
  end

  def create
    @account = Account.new(account_params)
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
    @teacher = Account.find(params[:id])
    @teacher.admin ? @teacher.update_attribute(:admin, false) : @teacher.update_attribute(:admin, true)
    redirect_to teachers_path
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
      :teacher,
      contacts_attributes: [:account_id, :first_name, :last_name, :email, :phone]
    )
  end
end
