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


  # def edit
  #   @price = Price.find(params[:id])
  # end
  #
  # def update
  #   @price = Price.find(params[:id])
  #   if @price.update(price_params)
  #     flash[:notice] = "Price Updated"
  #     redirect_to dashboard_index_path
  #   else
  #     flash[:alert] = @price.errors.full_messages.join(", ")
  #     render new_price_path
  #   end
  # end
  #
  # def destroy
  #   @price = Price.find(params[:id])
  #   if !current_account.prices.include?(@price)
  #     flash[:notice] = 'You are not authorized to delete this price'
  #     redirect_to dashboard_index_path and return
  #   else
  #     @price.destroy
  #     flash[:notice] = "Price Removed"
  #     redirect_to dashboard_index_path
  #   end
  # end

  private

  def price_params
    params.require(:price).permit(
      :tier_name,
      :duration,
      :price
    )
  end
end
