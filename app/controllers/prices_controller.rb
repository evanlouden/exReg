class PricesController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def create
    @price = Price.new(price_params)
    @prices = Price.all
    @instruments = Instrument.all
    @instrument = Instrument.new
    @reasons = Reason.all
    @reason = Reason.new
    @count = ExcusedAbsence.first
    @excused_absence = ExcusedAbsence.new
    if @price.save
      flash[:notice] = "Pricing Tier Added"
      redirect_to settings_admin_index_path
    else
      flash[:alert] = @price.errors.full_messages.join(", ")
      render "admin/settings"
    end
  end

  def edit
    @price = Price.find(params[:id])
  end

  def update
    @price = Price.find(params[:id])
    if @price.update(price_params)
      flash[:notice] = "Pricing Tier Updated"
      redirect_to settings_admin_index_path
    else
      flash[:alert] = @price.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @price = Price.find(params[:id])
    @price.destroy
    flash[:notice] = "Pricing Tier Removed"
    redirect_to settings_admin_index_path
  end

  private

  def price_params
    params.require(:price).permit(
      :tier_name,
      :duration,
      :price
    )
  end
end
