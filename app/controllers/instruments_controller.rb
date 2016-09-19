class InstrumentsController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def create
    @instrument = Instrument.new(instrument_params)
    @instruments = Instrument.all
    @prices = Price.all
    @price = Price.new
    @reasons = Reason.all
    @reason = Reason.new
    @count = ExcusedAbsence.first
    @excused_absence = ExcusedAbsence.new
    if @instrument.save
      flash[:notice] = "Instrument Added"
      redirect_to settings_admin_index_path
    else
      flash[:alert] = @instrument.errors.full_messages.join(", ")
      render "admin/settings"
      flash.discard(:alert)
    end
  end

  def edit
    @instrument = Instrument.find(params[:id])
  end

  def update
    @instrument = Instrument.find(params[:id])
    if @instrument.update(instrument_params)
      flash[:notice] = "Instrument Updated"
      redirect_to settings_admin_index_path
    else
      flash[:alert] = @instrument.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @instrument = Instrument.find(params[:id])
    @instrument.destroy
    flash[:notice] = "Instrument Removed"
    redirect_to settings_admin_index_path
  end

  private

  def instrument_params
    params.require(:instrument).permit(
      :name
    )
  end
end
