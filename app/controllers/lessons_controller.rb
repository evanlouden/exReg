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
      flash[:notice] = "Student Registered"
      redirect_to admin_index_path
    else
      flash[:alert] = @lesson.errors.full_messages.join(", ")
      @hidden = ""
      render "inquiries/show", location: inquiry_path(@inquiry)
    end
  end

  def index
    @students = if current_account.type == "Teacher"
                  current_account.students
                else
                  Student.all
                end
    @lessons = []
    @students.each do |student|
      unless student.lessons.empty?
        student.lessons.map { |lesson| @lessons << lesson }
      end
    end
    @lessons.sort_by! { |l| [l.teacher.contacts.first.last_name, l.student.last_name] }
  end

  def attended
    @lesson = Lesson.find(params[:id])
    @lesson.attended += 1
    @lesson.save
    if current_account.type == "Teacher"
      redirect_to teacher_path(current_account)
    else
      redirect_to admin_index_path
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
      :teacher_id,
      :inquiry_id
    )
  end
end
