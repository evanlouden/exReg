class DashboardController < PermissionsController
  def index
    @contacts = current_account.contacts
    @students = current_account.students
  end
end
