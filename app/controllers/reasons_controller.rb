class ReasonsController < PermissionsController
  before_action :authenticate_account!
  before_action :require_admin

  def index
    @reasons = Reason.all
    @reason = Reason.new
  end

  def create
    @reason = Reason.new(reason_params)
    if @reason.save
      flash[:notice] = "Reason Added"
      redirect_to reasons_path
    else
      flash[:alert] = @reason.errors.full_messages.join(", ")
      render :index
    end
  end

  def edit
    @reason = Reason.find(params[:id])
  end

  def update
    @reason = Reason.find(params[:id])
    if @reason.update(reason_params)
      flash[:notice] = "Reason Updated"
      redirect_to reasons_path
    else
      flash[:alert] = @reason.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @reason = Reason.find(params[:id])
    @reason.destroy
    flash[:notice] = "Reason Removed"
    redirect_to reasons_path
  end

  private

  def reason_params
    params.require(:reason).permit(
      :reason,
      :teacher_paid,
      :student_charged
    )
  end
end
