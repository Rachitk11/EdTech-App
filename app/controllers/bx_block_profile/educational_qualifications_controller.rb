module BxBlockProfile
  class EducationalQualificationsController < ApplicationController

    def index
     @educational_qualifications = EducationalQualification.all
     render json: EducationalQualificationSerializer.new(@educational_qualifications, meta: {
         message: "Successfully Loaded"
      }).serializable_hash, status: :ok
      #render json: {educational_qualifications: @educational_qualifications, full_messages: "Successfully Loaded"}
    end

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @educational_qualification = BxBlockProfile::EducationalQualification.new(
                                      educational_qualification_params.merge({ profile_id: @profile.id} ))

        if @educational_qualification.save
          create_field_study && create_degree
          render json: BxBlockProfile::EducationalQualificationSerializer.new(@educational_qualification
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@educational_qualification.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def show
      educational_qualification = BxBlockProfile::EducationalQualification.find_by(id: params[:id])
      render json: EducationalQualificationSerializer.new(educational_qualification, meta: {
        message: ""
      }).serializable_hash, status: :ok
    end

    def update
      educational_qualification = BxBlockProfile::EducationalQualification.find_by(id: params[:id])
      if educational_qualification.present?
        educational_qualification.update(educational_qualification_params)
        render json: EducationalQualificationSerializer.new(educational_qualification, meta: {
            message: "Educational Qualification updated successfully"
          }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(educational_qualification.errors)
        }, status: :unprocessable_entity
      end
    end

    def destroy
      educational_qualification = BxBlockProfile::EducationalQualification.find_by(id: params[:id])
      if educational_qualification&.destroy
        render json:{ meta: { message: "Educational Qualification Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end


    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def educational_qualification_params
      params.require(:educational_qualification).permit \
       :id,
       :school_name,
       :start_date,
       :end_date,
       :grades,
       :description,
       :make_grades_public
    end

    def create_field_study
      field_study = FieldStudy.where(field_of_study: params[:field_of_study]).first
      if field_study.present?
        EducationalQualificationFieldStudy.create(educational_qualification_id: @educational_qualification.id,
                                                   field_study_id: field_study.id)
      else
        field_study = FieldStudy.create(field_of_study: params[:field_of_study])
        EducationalQualificationFieldStudy.create(educational_qualification_id: @educational_qualification.id,
                                                   field_study_id: field_study.id)
      end
    end

    def create_degree
      degree = Degree.where(degree_name: params[:degree_name]).first
      if degree.present?
        DegreeEducationalQualification.create(educational_qualification_id: @educational_qualification.id,
                                               degree_id: degree.id)
      else
        degree = Degree.create(degree_name: params[:degree_name])
        DegreeEducationalQualification.create(educational_qualification_id: @educational_qualification.id,
                                               degree_id: degree.id)
      end
    end

  end
end
