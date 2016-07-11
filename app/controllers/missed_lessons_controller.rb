class MissedLessonsController < PermissionsController
  def create
    @lesson = Lesson.find(params[:missed_lesson][:lesson_id])
    @missed_lesson = MissedLesson.new(missed_lessons_params)
    @missed_lesson.save
    @lesson.attended += 1 if @missed_lesson.reason.student_charged
    redirect teacher_path(current_account)
  end

  private

  def missed_lessons_params
    params.require(:missed_lesson).permit(
    :reason_id,
    :date,
    :lesson_id
    ).merge(date: @lesson.absence_date)
  end
end
