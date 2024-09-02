module BxBlockProfile
  class CurrentStatusController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")
      if @profile.present?
        @current_status = @profile.create_current_status(current_status_params)

        if @current_status.save
          create_industry && create_employment_type && create_current_annual_salary
          render json: BxBlockProfile::CurrentStatusSerializer.new(@current_status
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@current_status.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def current_status_params
      params.require(:current_status).permit \
        :most_recent_job_title,
        :company_name,
        :notice_period,
        :end_date
    end

    def create_industry
      industry = Industry.where(industry_name: params[:industry_name]).first
      if industry.present?
        CurrentStatusIndustry.create(current_status_id: @current_status.id, industry_id: industry.id)
      else
        industry = Industry.create(industry_name: params[:industry_name])
        CurrentStatusIndustry.create(current_status_id: @current_status.id, industry_id: industry.id)
      end
    end

    def create_employment_type
      employment_type = EmploymentType.where(employment_type_name: params[:employment_type_name]).first
      if employment_type.present?
        CurrentStatusEmploymentType.create(current_status_id: @current_status.id,
                                           employment_type_id: employment_type.id)
      else
        employment_type = EmploymentType.create(employment_type_name: params[:employment_type_name])
        CurrentStatusEmploymentType.create(current_status_id: @current_status.id,
                                           employment_type_id: employment_type.id)
      end
    end

    def create_current_annual_salary
      current_annual_salary = CurrentAnnualSalary.where(current_annual_salary: params[:current_annual_salary]).first
      if current_annual_salary.present?
        CurrentAnnualSalaryCurrentStatus.create(current_status_id: @current_status.id,
                                                 current_annual_salary_id: current_annual_salary.id)
      else
        current_annual_salary = CurrentAnnualSalary.create(current_annual_salary: params[:current_annual_salary])
        CurrentAnnualSalaryCurrentStatus.create(current_status_id: @current_status.id,
                                                 current_annual_salary_id: current_annual_salary.id)
      end
    end

  end
end
