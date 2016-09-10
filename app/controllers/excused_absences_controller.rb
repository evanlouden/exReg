class ExcusedAbsencesController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def create
    @excused_absence = ExcusedAbsence.new(excused_absences_params)
    @count = ExcusedAbsence.first
    @prices = Price.all
    @price = Price.new
    @instruments = Instrument.all
    @instrument = Instrument.new
    @reasons = Reason.all
    @reason = Reason.new
    if @excused_absence.save
      flash[:notice] = "Count Added"
      redirect_to settings_admin_index_path
    else
      flash[:alert] = @excused_absence.errors.full_messages.join(", ")
      render "admin/settings"
    end
  end

  def update
    @excused_absence = ExcusedAbsence.first
    if @excused_absence.update(excused_absences_params)
      flash[:notice] = "Count Updated"
    else
      flash[:alert] = @excused_absence.errors.full_messages.join(", ")
    end
    redirect_to settings_admin_index_path
  end

  private

  def excused_absences_params
    params.require(:excused_absence).permit(
      :count
    )
  end
end
