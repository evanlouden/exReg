module Api::V1
  class CalendarController < PermissionsController
    respond_to :json, :js

    def index
      @lessons = current_account.lessons
      @students = []
      @lessons.map { |l| @students << l.student.full_name }
      response = { lessons: @lessons, students: @students }
      render json: response
    end
  end
end
