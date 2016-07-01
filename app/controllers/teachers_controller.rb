class TeachersController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin, only: :index

  def index
    @teachers = Account.where(teacher: true).order(email: :desc)
    @admins = Account.where(admin: true).order(email: :desc)
  end

  def show
    @lessons = current_account.lessons
  end
end
