class DashboardController < ApplicationController
  def index
    @students = current_account.students
  end
end
