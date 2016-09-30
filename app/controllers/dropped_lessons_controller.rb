class DroppedLessonsController < PermissionsController

  def create
    @dropped_lesson_form = DroppedLessonForm.new(dropped_lesson_params)
    lesson = Lesson.find(dropped_lesson_params[:lesson_id])
    @student = Student.find(lesson.student.id)
    @inquiries = @student.pending_inquiries
    @lessons = @student.lessons
    @dropped_lesson_form.persist
    flash[:notice] = "Lesson(s) Dropped"
    redirect_to student_path(@student)
  rescue => e
    flash[:error] = @dropped_lesson_form.print_errors
    render "students/show"
  end

  private

  def dropped_lesson_params
    params.require(:dropped_lesson_form).permit(
    :lesson_amount,
    :effective_date,
    :reason,
    :transaction_amount,
    :transaction_type,
    :lesson_id,
    :family_id,
    :admin_id
  )
  end
end
