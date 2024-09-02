module BxBlockProfile
  class CurrentStatusSerializer < BuilderBase::BaseSerializer
    attributes *[
      :most_recent_job_title,
      :company_name,
      :notice_period,
      :end_date,
      :profile_id
    ]

    attributes :current_status_industrys do |object|
      object.current_status_industrys.map do |cur_ind|
        {
          id: cur_ind.industry.id,
          industry_name: cur_ind.industry.industry_name
        }
      end
    end

    attributes :current_status_employment_types do |object|
      object.current_status_employment_types.map do |cur_emp|
        {
          id:cur_emp.employment_type.id,
          employment_type_name: cur_emp.employment_type.employment_type_name
        }
      end
    end

    attributes :current_annual_salary_current_status do |object|
      object.current_annual_salary_current_status.map do |sal_stat|
        {
          id:sal_stat.current_annual_salary.id,
          employment_type_name: sal_stat.current_annual_salary.current_annual_salary
        }
      end
    end

  end
end