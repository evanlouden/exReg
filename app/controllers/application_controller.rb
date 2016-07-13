class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resources)
    if current_account.admin
      admin_index_path
    elsif current_account.teacher && !current_account.admin
      teacher_path(current_account)
    else
      dashboard_index_path
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

  def clear_times(availabilities)
    availabilities.each do |a|
      if a.checked == "0"
        a.start_time = nil
        a.end_time = nil
        a.save
      end
    end
  end

  def sort_avails(array)
    days = Availability::DAYS
    lookup = {}

    days.each_with_index do |day, index|
      lookup[day] = index
    end

    array.sort_by do |item|
      lookup.fetch(item.day)
    end
  end
end
