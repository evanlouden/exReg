class AdjustedLessonsController < PermissionsController

  def create
    @adjusted_lesson_form = AdjustedLessonForm.new(adjusted_lesson_params)
    lesson = Lesson.find(adjusted_lesson_params[:lesson_id])
    @student = Student.find(lesson.student.id)
    @inquiries = @student.pending_inquiries
    @lessons = @student.lessons
    @adjusted_lesson_form.persist
    flash[:notice] = "Adjustments Added"
    redirect_to student_path(@student)
  rescue => e
    flash[:error] = @adjusted_lesson_form.print_errors
    render "students/show"
  end

  private

  def adjusted_lesson_params
    params.require(:adjusted_lesson_form).permit(
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
