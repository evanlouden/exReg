class PermissionsController < ApplicationController
  def require_admin
    session[:current_page] ||= request.referer
    unless current_account.admin
      flash[:alert] = 'You do not have permission to access this page'
      redirect_to authenticated_root_path
    end
  end
end
