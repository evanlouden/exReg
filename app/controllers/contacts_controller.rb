class ContactsController < PermissionsController
  def new
    @contact = Contact.new
  end

  def create
    @contact = current_account.contacts.build(contact_params)
    if @contact.save
      flash[:notice] = "Contact Added"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @contact.errors.full_messages.join(", ")
      render new_contact_path
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      flash[:notice] = "Contact Updated"
      redirect_to dashboard_index_path
    else
      flash[:alert] = @contact.errors.full_messages.join(", ")
      render new_contact_path
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    if !current_account.contacts.include?(@contact)
      flash[:notice] = 'You are not authorized to delete this contact'
      redirect_to dashboard_index_path and return
    else
      @contact.destroy
      flash[:notice] = "Contact removed"
      redirect_to dashboard_index_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :account_id,
    )
  end
end
