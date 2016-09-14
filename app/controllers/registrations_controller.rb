class RegistrationsController < Devise::RegistrationsController
  def new
    @states = Account::STATES
    build_resource({type: "Family"})
    self.resource.contacts << Contact.new
    respond_with self.resource
  end

  def create
    @states = Account::STATES
    super
  end

  def edit
    @states = Account::STATES
    super
  end

  def update
    @states = Account::STATES
    super
  end
end
