class DashboardController < PermissionsController
  def index
    @contacts = current_account.contacts
    @students = current_account.students
    @lessons = []
    @students.each do |student|
      unless student.lessons.empty?
        student.lessons.map { |lesson| @lessons << lesson }
      end
    end
  end
end
