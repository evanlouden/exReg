module Api::V1
  class CalendarController < PermissionsController

    def index
      @teacher = Teacher.find(params[:id])
      render json: @teacher.calendar_json
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
