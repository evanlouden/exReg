class ApplicationController < ActionController::Base
  include AvailsHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resources)
    if current_account.admin && current_account.teacher
      adminteacher_root_path
    elsif current_account.admin
      admin_root_path
    elsif current_account.teacher
      teacher_root_path
    else
      family_root_path
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :address,
      :city,
      :state,
      :zip,
      :type,
      contacts_attributes: [
        :id,
        :first_name,
        :last_name,
        :email,
        :phone,
        :primary,
        :account_id
      ]
    )}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(
      :email,
      :password,
      :password_confirmation,
      :current_password,
      :address,
      :city,
      :state,
      :zip,
      :type)
    }
  end
end
