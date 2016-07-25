module Api::V1
  class CalendarController < PermissionsController
    respond_to :json, :js

    def index
      teachers = Teacher.all.sort_by { |t| t.contacts.first.last_name }
      render json: teachers
    end
  end
end
