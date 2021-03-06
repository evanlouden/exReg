class LessonsController < PermissionsController

  def create
    @inquiry = Inquiry.find(params[:inquiry_id])
    @student = @inquiry.student
    @lesson = @student.lessons.build(lesson_params)
    @days = Availability::DAYS
    @teachers = Teacher.all
    @instruments = Instrument.all
    @price_tier = Price.find(params[:lesson][:tier_name])
    @lesson.tier_name = @price_tier.tier_name
    @lesson.duration = @price_tier.duration
    @lesson.price = @price_tier.price
    @lesson.inquiry = @inquiry
    if @lesson.save
      @lesson.inquiry.update_attribute(:completed, true)
      @lesson.update_attribute(:excused_remaining, ExcusedAbsence.first.count)
      Debit.create(family: @student.family, admin: current_account, amount: @lesson.initial_balance, description: "Lesson Registration")
      flash[:notice] = "Student Registered"
      redirect_to admin_index_path
    else
      flash[:alert] = @lesson.errors.full_messages.join(", ")
      @hidden = ""
      render "inquiries/show", location: inquiry_path(@inquiry)
    end
  end

  def index
    @lessons = Lesson.all_active_lessons
  end

  def attended
    @lesson = Lesson.find(params[:id])
    @lesson.attended += 1
    @lesson.save
    redirect_to teacher_path(@lesson.teacher)
  end

  private

  def lesson_params
    params.require(:lesson).permit(
      :day,
      :start_date,
      :start_time,
      :duration,
      :purchased,
      :attended,
      :instrument,
      :tier_name,
      :price,
      :student_id,
      :teacher_id,
      :inquiry_id
    )
  end
end
