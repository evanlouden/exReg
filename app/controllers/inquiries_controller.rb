class InquiriesController < PermissionsController
  before_action :authenticate_account!
  
  def new
    @student = Student.find(params[:student])
    @inquiry = @student.inquiries.build
    @days = Availability::DAYS
    @days.each do |item|
      @inquiry.availabilities.build(day: item)
    end
    @availabilities = @student.inquiries.last.availabilities
  end

  def create
    @student = Student.find(params[:inquiry][:student_id])
    @inquiry = @student.inquiries.build(inquiry_params)
    @availabilities = @student.inquiries.last.availabilities
    if @inquiry.save
      clear_times(@availabilities)
      flash[:notice] = "Inquiry Submitted"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @inquiry.errors.full_messages.join(", ")
      render new_inquiry_path
    end
  end

  def edit
    @inquiry = Inquiry.find(params[:id])
    @student = @inquiry.student
    @availabilities = @inquiry.availabilities
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    @student = @inquiry.student
    @availabilities = @inquiry.availabilities
    if @inquiry.update(inquiry_params)
      clear_times(@availabilities)
      flash[:notice] = "Inquiry Updated"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @inquiry.errors.full_messages.join(", ")
      render :edit
    end
  end

  def inquiry_params
    params.require(:inquiry).permit(
      :id,
      :instrument,
      :student_id,
      :notes,
      :student,
      availabilities_attributes: [:id, :checked, :day, :start_time, :end_time]
    )
  end
end
