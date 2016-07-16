class PermissionsController < ApplicationController
  def require_admin
    session[:current_page] ||= request.referer
    unless current_account.admin
      flash[:alert] = "You do not have permission to access this page"
      if current_account.teacher
        redirect_to teacher_root_path
      else
        redirect_to family_root_path
      end
    end
  end
end
