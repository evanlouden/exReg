class PricesController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @prices = Price.all
    @price = Price.new
  end

  def create
    @price = Price.new(price_params)
    if @price.save
      flash[:notice] = "Price Added"
      redirect_to prices_path
    else
      flash[:alert] = @price.errors.full_messages.join(", ")
      render :index
    end
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
