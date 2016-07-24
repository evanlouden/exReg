class ExcusedAbsencesController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @count = ExcusedAbsence.first
    @excused_absence = ExcusedAbsence.new
  end

  def create
    @excused_absence = ExcusedAbsence.new(excused_absences_params)
    if @excused_absence.save
      flash[:notice] = "Count Added"
      redirect_to excused_absences_path
    else
      flash[:alert] = @excused_absence.errors.full_messages.join(", ")
      render :index
    end
  end

  def update
    @excused_absence = ExcusedAbsence.first
    if @excused_absence.update(excused_absences_params)
      flash[:notice] = "Count Updated"
    else
      flash[:alert] = @excused_absence.errors.full_messages.join(", ")
    end
    redirect_to excused_absences_path
  end

  private

  def excused_absences_params
    params.require(:excused_absence).permit(
      :count
    )
  end
end
