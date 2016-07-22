class ContactsController < PermissionsController
  def index
    @contacts = current_account.contacts
    @primary = @contacts.select(&:primary).first
    @nonprimary = @contacts.select { |c| !c.primary }
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = current_account.contacts.build(new_contact_params)
    if @contact.save
      flash[:notice] = "Contact Added"
      redirect_to contacts_path
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
    if @contact.update(update_contact_params)
      flash[:notice] = "Contact Updated"
      redirect_to contacts_path
    else
      flash[:alert] = @contact.errors.full_messages.join(", ")
      render new_contact_path
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    if !current_account.contacts.include?(@contact)
      flash[:notice] = "You are not authorized to delete this contact"
      redirect_to dashboard_index_path and return
    else
      @contact.destroy
      flash[:notice] = "Contact Removed"
      redirect_to contacts_path
    end
  end

  def change
    @contacts = current_account.contacts
    @contact = Contact.find(params[:id])
    @contacts.map { |c| c.update_attribute(:primary, false) }
    @contact.update_attribute(:primary, true)
    redirect_to contacts_path
  end

  private

  def new_contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :primary,
      :account_id,
    ).merge(primary: false)
  end

  def update_contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :primary,
      :account_id,
    )
  end
end
