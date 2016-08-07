module Api::V1
  class TeacherController < PermissionsController
    # respond_to :json, :js

    def index
      @teachers = Teacher.joins(:instruments).where("instruments.name = ?", params[:instrument])
      @names = []
      @teachers.each do |t|
        @names << t.staff_name
      end
      response = {
        teachers: @teachers,
        fullNames: @names
      }
      render json: response
    end
  end
end
