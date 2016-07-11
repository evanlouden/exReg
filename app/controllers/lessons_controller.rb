class LessonsController < PermissionsController
  def new
    @student = Student.find(params[:student])
    @inquiry = Inquiry.find(params[:inquiry])
    @lesson = @student.lessons.build
    @lesson.inquiry = @inquiry
    @days = Availability::DAYS
    @teachers = Teacher.all
    @instruments = Instrument.all
  end

  def create
    @student = Student.find(params[:lesson][:student_id])
    @inquiry = Inquiry.find(params[:lesson][:inquiry_id])
    @lesson = @student.lessons.build(lesson_params)
    @days = Availability::DAYS
    @teachers = Teacher.all
    @instruments = Instrument.all
    @price_tier = Price.find(params[:lesson][:tier_name])
    @lesson.tier_name = @price_tier.tier_name
    @lesson.duration = @price_tier.duration
    @lesson.price = @price_tier.price
    if @lesson.save
      @lesson.inquiry.update_attribute(:completed, true)
      flash[:notice] = "Student Registered"
      redirect_to admin_index_path
    else
      flash[:alert] = @lesson.errors.full_messages.join(", ")
      render :new
    end
  end

  def index
    @students = Student.all
    @lessons = []
    @students.each do |student|
      unless student.lessons.empty?
        student.lessons.map { |lesson| @lessons << lesson }
      end
    end
  end

  def attended
    @lesson = Lesson.find(params[:id])
    @lesson.attended += 1
    @lesson.save
    redirect_to teacher_path(current_account)
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
