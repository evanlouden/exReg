module Api::V1
  class CalendarController < PermissionsController
    # respond_to :json, :js

    def index
      @teacher = Teacher.find(params[:id])
      @lessons = @teacher.lessons
      @students = []
      @lessons.map { |l| @students << l.student.full_name }
      response = { lessons: @lessons, students: @students }
      render json: response
    end

    def create
      lesson_params = params[:lessons]
      lesson_params.each do |a|
        lesson = Lesson.find(a[:id])
        lesson.day = a[:day]
        lesson.start_time = a[:start_time]
        lesson.save
      end
    end
  end
end
