class LessonsController < PermissionsController
  def new
    @student = Student.find(params[:student])
    @lesson = @student.lessons.build
    @students = Student.all
    @days = Availability::DAYS
    @teachers = Account.all.where(teacher: true)
  end

  def create
    @student = Student.find(params[:lesson][:student_id])
    @lesson = @student.lessons.build(lesson_params)
    @days = Availability::DAYS
    @teachers = Account.all.where(teacher: true)
    @price_tier = Price.find(params[:lesson][:tier_name])
    @lesson.tier_name = @price_tier.tier_name
    @lesson.duration = @price_tier.duration
    @lesson.price = @price_tier.price
    if @lesson.save
      flash[:notice] = "Student Registered"
      redirect_to admin_index_path
    else
      flash[:alert] = @lesson.errors.full_messages.join(", ")
      render :new
    end
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
      :account_id,
    )
  end
end
