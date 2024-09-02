module BxBlockProfile
  class LanguagesController < ApplicationController

    before_action :validate_json_web_token

    PROFICIENCY = [:mediam, :advance]

    def proficiency
      render json: {proficiences: BxBlockProfile::LanguagesController::PROFICIENCY }
    end

    def index
     @languages = Language.all
      render json: {languages: @languages, full_messages: "Successfully Loaded"}
    end

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")
      if @profile.present?

        @language = BxBlockProfile::Language.new(language_params.merge({ profile_id: @profile.id} ))
        if @language.save
          render json: BxBlockProfile::LanguageSerializer.new(@language
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@language.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def show
      language = BxBlockProfile::Language.find_by(id: params[:id])

      if language.present?
        render json: BxBlockProfile::LanguageSerializer.new(language, meta: {
        message: ""
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def update
      language = BxBlockProfile::Language.find_by(id: params[:id])
      if language.present?
        language.update(language_params)
        render json: LanguageSerializer.new(language, meta: {
            message: "Language updated successfully"
          }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(language.errors)
        }, status: :unprocessable_entity
      end
    end

    def destroy
      language = BxBlockProfile::Language.find_by(id: params[:id])
      if language&.destroy
        render json:{ meta: { message: "Language Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end


    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def language_params
      params.require(:language).permit \
       :id,
       :language,
       :proficiency
    end
  end
end
