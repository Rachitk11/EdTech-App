# frozen_string_literal: true

module BxBlockProfileBio
  # app/controller/ProfileBiosController
  class ProfileBiosController < ApplicationController
    before_action :load_account, only: %i[show]
    before_action :check_account_activated, only: %i[update show destroy]

    def create
      profile = BxBlockProfileBio::ProfileBio.includes(:account).find_by(accounts: {id: current_user.id})
      if profile.present?
        render json: {errors: [
          {profile: "Profile bio has been already created"}
        ]}, status: :unprocessable_entity and return
      end

      begin
        profile_bio = current_user.build_profile_bio(profile_params)

        if profile_bio.valid? && profile_bio.save
          render json: BxBlockProfileBio::ProfileBioSerializer.new(profile_bio).serializable_hash, status: :created
        else
          render_create_validation_errors(profile_bio)
        end
      rescue Exception => e
        render json: {errors: [e.message]},
          status: :unprocessable_entity
      end
    end

    def update
      profile =current_user.try(:profile_bio)
      if profile.nil?
        render json: {
          message: "Profile bio doesn't exists"
        }, status: :not_found and return
      end

      profile.assign_attributes(profile_params)

      if profile.valid?
        profile.save
        update_profile_bio(profile)
      else
        render json: {errors: [
          {profile: profile.errors.full_messages}
        ]}, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: {errors: [e.message]},
        status: :unprocessable_entity
    end

    def destroy
      profile =current_user.try(:profile_bio)
      if profile.nil?
        render json: {
          message: "Profile bio doesn't exists"
        }, status: :not_found and return
      elsif profile.destroy!
        render json: {message: "Deleted Successfully"}, status: :ok
      end
    rescue Exception => e
      render json: {errors: [e.message]},
        status: :unprocessable_entity
    end

    def index
      profile = BxBlockProfileBio::ProfileBio.includes(:account)
        .find_by(accounts: {id: current_user.id})
      if profile.nil?
        render json: {
          message: "Profile bio doesn't exists"
        }, status: :not_found and return
      else
        render json: BxBlockProfileBio::ProfileBioSerializer.new(profile).serializable_hash, status: :ok
      end
    end

    def fetch_interests
      interests_values = BxBlockProfileBio::ProfileBio::INTERESTS_VALUES
      if params[:search_item].present?
        interests_values = interests_values.select { |item| item.downcase.include?(params[:search_item]) }
      end
      render json: interests_values,
        status: :ok
    end

    def fetch_personalities
      personalities_values = BxBlockProfileBio::ProfileBio::PERSONALITY_VALUES
      if params[:search_item].present?
        personalities_values = personalities_values.select { |item| item.downcase.include?(params[:search_item]) }
      end
      render json: personalities_values,
        status: :ok
    end

    private

    def update_profile_bio(profile)
      profile.save
      render json: BxBlockProfileBio::ProfileBioSerializer.new(profile).serializable_hash, status: :ok
    end

    def render_create_validation_errors(profile_bio)
      errors_arr = []
      errors_arr << profile_bio.errors.full_messages if profile_bio.errors.present?
      errors_arr << current_user.errors.full_messages if current_user.errors.present?
      render json: {errors: errors_arr}, status: :unprocessable_entity
    end

    def profile_params
      params.require(:data)[:attributes].permit(
        :height, :weight, :height_type, :weight_type, :body_type, :mother_tougue,
        :religion, :zodiac, :marital_status, :smoking, :drinking, :looking_for,
        :about_me, :about_business, :category_id, custom_attributes: {}, languages: [], personality: [],
        interests: [],
        educations_attributes: %i[id qualification description year_from year_to _destroy],
        achievements_attributes: %i[id title achievement_date detail url _destroy],
        careers_attributes: [:id, :profession, :is_current, :experience_from,
          :experience_to, :payscale, :company_name, :sector, :_destroy, {
            accomplishment: []
          }]
      )
    end

    def load_account
      @account = AccountBlock::Account.find_by(id: params[:id])

      if @account.nil?
        render json: {
          message: "Account doesn't exists"
        }, status: :not_found
      end
    end
  end
  # rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Naming/MemoizedInstanceVariableName, Metrics/MethodLength, Style/GuardClause, Layout/LineLength, Lint/RescueException
end
