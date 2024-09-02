module BxBlockProfile
  class ProfilesController < ApplicationController
    before_action :validate_json_web_token, :current_user, only: [:show, :update]

    def show
      profile = current_user.profile
      if profile&.present?
        render json: ProfileSerializer.new(profile, serialization_options).serializable_hash,status: :ok
      else
        render json: {
          message: "Profile not found"
        }, status: :unprocessable_entity
      end
    end

    def show_about_us
      term = BxBlockTermsAndConditions::TermsAndCondition.last
      about_us = BxBlockContentManagement::AboutUs.last
      if term.present? && about_us.present?
        render json: {data: {content:[{type: "Term", term: term}, {type: "About Us", about_us: about_us}]}}, status: :ok
      else
        render json: {message: "Data not found"}, status: :not_found
      end
    end

    def show_faq
      faq = BxBlockContentManagement::FaqQuestion.all
      if faq.present?
        render json: {data: {faq: faq}}, status: :ok
      else
        render json: {message: "Data not found"}, status: :not_found
      end
    end

    def update
      profile = current_user.profile
      if profile&.present?
        if profile&.update(profile_params)
          current_user.update(profile_params.merge(first_name: profile_params[:user_name]))
          render json: ProfileSerializer.new(profile, serialization_options).serializable_hash, status: :ok
        else
          render json: { message: "Profile update failed" }, status: :unprocessable_entity
        end
      else
        render json: { message: "Invalid parameters for the user role" }, status: :unprocessable_entity
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end

    # Added required params need to be updated
    def profile_params
      params.require(:profile).permit(:photo,:user_name, :guardian_email,:school_id, :student_unique_id, :guardian_name, :guardian_contact_no, :email, :teacher_unique_id, :school_id, :full_phone_number, :employee_unique_id,:publication_house_name, :first_name, :last_name, :department )
    end
  end
end