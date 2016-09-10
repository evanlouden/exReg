class TransactionsController < PermissionsController
  def create
    @family = Family.find(transaction_params[:family_id])
    @students = @family.students
    @transactions = Transaction.where(family: @family)
    @contacts = @family.contacts.select { |c| !c.primary }
    @transaction = current_account.transactions.build(transaction_params)
    if @transaction.save
      flash[:notice] = "#{@transaction.type} Added"
      redirect_to summary_admin_index_path(family_id: @family.id)
    else
      flash[:alert] = @transaction.errors.full_messages.join(", ")
      render "admin/summary"
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @family = @transaction.family
    flash[:notice] = "#{@transaction.type} Removed"
    @transaction.destroy
    redirect_to summary_admin_index_path(family_id: @family.id)
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      :amount,
      :type,
      :family_id
    )
  end
end
