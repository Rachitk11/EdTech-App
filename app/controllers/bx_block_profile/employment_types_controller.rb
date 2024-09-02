module BxBlockProfile
  class EmploymentTypesController < ApplicationController
    skip_before_action :validate_json_web_token
    def create
      @emp_type = BxBlockProfile::EmploymentType.create(emp_type_params)
      if @emp_type.save
        render json: { data: @emp_type, message: 'New Employment Type Added' }, status: :created
      else
        render json: {
          errors: format_activerecord_errors(@emp_type.errors)
        }, status: :unprocessable_entity
      end
    end

    def index
      @emp_types = BxBlockProfile::EmploymentType.all
      render json: { data: @emp_types }, status: :ok
    end

    def show
      @emp_type = BxBlockProfile::EmploymentType.find(params[:id])
      render json: { data: @emp_type }, status: :ok
    end

    private

    def emp_type_params
      params.require(:employment_type).permit \
        :employment_type_name
    end
  end
end
