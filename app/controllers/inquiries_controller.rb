class InquiriesController < PermissionsController
  before_action :authenticate_account!

  def new
    @student = Student.find(params[:student])
    @inquiry = @student.inquiries.build
    @instruments = Instrument.all
  end

  def show
    @inquiry = Inquiry.find(params[:id])
    @student = @inquiry.student
    @instruments = Instrument.all
    @teachers = Teacher.all
    @inquiry_instrument = Instrument.find_by(name: @inquiry.instrument)
  end

  def create
    @instruments = Instrument.all
    @student = Student.find(params[:inquiry][:student_id])
    @inquiry = @student.inquiries.build(inquiry_params)
    if @inquiry.save
      flash[:notice] = "Inquiry Submitted"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @inquiry.errors.full_messages.join(", ")
      render new_inquiry_path
    end
  end

  def edit
    @instruments = Instrument.all
    @inquiry = Inquiry.find(params[:id])
    @student = @inquiry.student
  end

  def update
    @instruments = Instrument.all
    @inquiry = Inquiry.find(params[:id])
    @student = @inquiry.student
    if @inquiry.update(inquiry_params)
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
      :student
    )
  end
end
