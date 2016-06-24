class RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    self.resource.contacts << Contact.new
    respond_with self.resource
  end

  def create
    super
  end

  protected

  def after_sign_up_path_for(_resource)
    new_student_path
  end
end
