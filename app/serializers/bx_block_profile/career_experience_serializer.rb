module BxBlockProfile
  class CareerExperienceSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :job_title,
      :start_date,
      :end_date,
      :company_name,
      :description,
      :add_key_achievements,
      :make_key_achievements_public,
      :profile_id,
      :current_salary,
      :currently_working_here,
      :notice_period,
      :notice_period_end_date
    ]

    attributes :career_experience_industrys do |object|
      object.career_experience_industrys.map do |car_ind|
        {
          id: car_ind.industry.id,
          industry_name: car_ind.industry.industry_name
        }
      end
    end

    attributes :career_experience_employment_types do |object|
      object.career_experience_employment_types.map do |car_emp|
        {
          id:car_emp.employment_type.id,
          employment_type_name: car_emp.employment_type.employment_type_name
        }
      end
    end

    attributes :career_experience_system_experiences do |object|
      object.career_experience_system_experiences.map do |car_exp|
        {
          id:car_exp.system_experience.id,
          system_experience: car_exp.system_experience.system_experience
        }
      end
    end

  end
end
