module Api::V1
  class CalendarController < PermissionsController
    # respond_to :json, :js

    def index
      @teacher = Teacher.find(params[:id])
      @time = @teacher.earliest_start_time
      @end_time = @teacher.latest_end_time
      @lessons = @teacher.lessons
      @students = []
      @avail_hash = {}
      @lessons.map { |l| @students << l.student.full_name }
      @availabilities = sort_avails(@teacher.availabilities)
      @availabilities.each do |a|
        time_hash = {}
        if a.start_time
          time_hash[:start_time] = a.start_time
        else
          time_hash[:start_time] = nil
        end
        if a.end_time
          time_hash[:end_time] = a.end_time
        else
          time_hash[:end_time] = nil
        end
        @avail_hash[a.day] = time_hash
      end
      response = {
        time: @time,
        endTime: @end_time,
        lessons: @lessons,
        students: @students,
        availability: @avail_hash
      }
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
