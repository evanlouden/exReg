class TeacherInstrumentsController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @teachers = Teacher.all
    @instruments = Instrument.all
    @teacher_instrument = TeacherInstrument.new
  end

  def create
    @teachers = Teacher.all
    @instruments = Instrument.all
    @teacher_instrument = TeacherInstrument.new(teacher_instrument_params)
    if @teacher_instrument.save
      flash[:notice] = "Instrument associated"
      redirect_to teacher_instruments_path
    else
      flash[:error] = @teacher_instrument.errors.full_messages.join(", ")
      render :index
    end
  end

  def destroy
    @teacher_instrument = TeacherInstrument.find(params[:id])
    @teacher_instrument.destroy
    flash[:notice] = "Association removed"
    redirect_to teacher_instruments_path
  end

  private

  def teacher_instrument_params
    params.require(:teacher_instrument).permit(
      :instrument_id,
      :teacher_id
    )
  end
end
