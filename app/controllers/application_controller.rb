class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resources)
    current_account.admin ? admin_index_path : dashboard_index_path
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
      contacts_attributes: [
        :id,
        :first_name,
        :last_name,
        :email,
        :phone,
        :account_id]
    ) }
  end

  def clear_times(availabilities)
    availabilities.each do |a|
      if a.checked == "0"
        a.start_time = nil
        a.end_time = nil
        a.save
      end
    end
  end
end
