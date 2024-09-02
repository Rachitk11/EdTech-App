module BxBlockProfile
  class CareerExperiencesController < ApplicationController
    def index
     @career_experiences = CareerExperience.all
     render json: CareerExperienceSerializer.new(@career_experiences, meta: {
        message: "Successfully Loaded"
      }).serializable_hash, status: :ok
    end

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @career_experience = BxBlockProfile::CareerExperience.new(
          career_experience_params.merge({ profile_id: @profile.id} ))
        if @career_experience.save
          create_industry && create_employment_type && create_system_experience
          render json: BxBlockProfile::CareerExperienceSerializer.new(@career_experience
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@career_experience.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def show
      ce = BxBlockProfile::CareerExperience.find_by({id: params[:id]})

      if ce.present?
        render json: CareerExperienceSerializer.new(ce, meta: {
        message: "Career Experience"
      }).serializable_hash, status: :ok

      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def update
      career_experience = BxBlockProfile::CareerExperience.find_by(id: params[:id])
      if career_experience.present?
        career_experience.update(career_experience_params)
        render json: CareerExperienceSerializer.new(career_experience, meta: {
            message: "Career Experience updated successfully"
          }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(career_experience.errors)
        }, status: :unprocessable_entity
      end
    end

    def destroy
      career_experience = BxBlockProfile::CareerExperience.find_by(id: params[:id])
      if career_experience&.destroy
        render json:{ meta: { message: "Career Experience Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def career_experience_params
      params.require(:career_experience).permit \
        :id,
        :job_title,
        :start_date,
        :end_date,
        :company_name,
        :description,
        :make_key_achievements_public,
        :current_salary,
        :currently_working_here,
        :notice_period,
        :notice_period_end_date,
        add_key_achievements: []
    end

    def create_industry
      industry = Industry.where(industry_name: params[:industry_name]).first
      if industry.present?
        CareerExperienceIndustry.create(career_experience_id: @career_experience.id, industry_id: industry.id)
      else
        industry = Industry.create(industry_name: params[:industry_name])
        CareerExperienceIndustry.create(career_experience_id: @career_experience.id, industry_id: industry.id)
      end
    end

    def create_employment_type
      employment_type = EmploymentType.where(employment_type_name: params[:employment_type_name]).first
      if employment_type.present?
        CareerExperienceEmploymentType.create(career_experience_id: @career_experience.id,
                                              employment_type_id: employment_type.id)
      else
        employment_type = EmploymentType.create(employment_type_name: params[:employment_type_name])
        CareerExperienceEmploymentType.create(career_experience_id: @career_experience.id,
                                               employment_type_id: employment_type.id)
      end
    end

    def create_system_experience
      system_experience = SystemExperience.where(system_experience: params[:system_experience]).first
      if system_experience.present?
        CareerExperienceSystemExperience.create(career_experience_id: @career_experience.id,
                                                system_experience_id: system_experience.id)
      else
        system_experience = SystemExperience.create(system_experience: params[:system_experience])
        CareerExperienceSystemExperience.create(career_experience_id: @career_experience.id,
                                                 system_experience_id: system_experience.id)
      end
    end

  end
end
