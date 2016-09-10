class DashboardController < PermissionsController
  def index
    @students = current_account.students
    @balance = current_account.current_balance
    @lessons = []
    @students.each do |student|
      unless student.lessons.empty?
        student.lessons.map { |lesson| @lessons << lesson }
      end
    end
  end
end
