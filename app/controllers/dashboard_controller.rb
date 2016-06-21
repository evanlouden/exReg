class DashboardController < PermissionsController
  def index
    @students = current_account.students
  end
end
