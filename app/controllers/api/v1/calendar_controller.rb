module Api::V1
  class CalendarController < PermissionsController
    # respond_to :json, :js

    def create
      @teacher = Teacher.find(params[:id])
      @lessons = @teacher.lessons
      @students = []
      @lessons.map { |l| @students << l.student.full_name }
      response = { lessons: @lessons, students: @students }
      render json: response
    end
  end
end
