# frozen_string_literal: true

module BxBlockProfileBio
  # rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Style/GuardClause, Lint/RescueException, Lint/UselessAssignment
  # app/controller/PreferencesController
  class PreferencesController < ApplicationController
    before_action :load_basic_profile
    before_action :load_preference, only: %i[update index reset_preference]
    before_action :check_account_activated

    def index
      return if @preference.nil?

      render json: BxBlockProfileBio::PreferenceSerializer.new(@preference).serializable_hash,
             status: :ok
    end

    def create
      return if @account.nil?

      preference = @account.preference

      if preference.present?
        return render json: { errors: [
          { profile: 'Preference has been already created' }
        ] }, status: :unprocessable_entity
      end
      create_preference
    rescue Exception => e
      render json: { errors: [{ preference: e.message }] },
             status: :unprocessable_entity
    end

    def update
      return if @preference.nil?

      update_result = @preference.update(preference_params)
      if update_result
        render json: BxBlockProfileBio::PreferenceSerializer.new(@preference).serializable_hash,
               status: :ok
      else
        render json: { errors: [{ preference: @preference.errors }] },
               status: :unprocessable_entity
      end
    rescue Exception => e
      render json: { errors: [{ preference: e.message }] },
             status: :unprocessable_entity
    end

    def reset_preference
      return if @preference.nil?

      begin
        reset_params = {
          height_range_start: nil, height_range_end: nil, height_type: nil, location: nil, seeking: nil,
          age_range_start: nil, age_range_end: nil, distance: nil, smoking: nil, drinking: nil, body_type: nil,
          religion: nil, friend: false, business: false, match_making: false, travel_partner: false, cross_path: false
        }
        categories_name = @account.categories.map(&:name)

        arr_hash = {}
        if categories_name.present?
          categories_name.each do |category_name|
            arr_hash[category_name.to_sym.downcase] = true
          end
        end
        reset_params1 = reset_params.merge(arr_hash)

        @preference.update(reset_params1)
        render json: BxBlockProfileBio::PreferenceSerializer.new(@preference).serializable_hash,
               status: :ok
      rescue Exception => e
        render json: { errors: [{ preference: @preference.message }] },
               status: :unprocessable_entity
      end
    end

    private

    def preference_params
      params.require(:data)[:attributes].permit \
        :height_range_start, :height_range_end, :height_type, :location, :seeking,
        :age_range_start, :age_range_end, :distance, :smoking, :drinking, :body_type,
        :religion, :friend, :business, :match_making, :travel_partner, :cross_path
    end

    def create_preference
      preference = BxBlockProfileBio::Preference.new(preference_params)
      preference.account_id = @account.id
      if preference_params[:location].blank?
        account = AccountBlock::Account.find(current_user.id)
        location = account.location.as_json || {}
        preference.location = location['address'] if location.present?
      end

      if preference.save
        serializer = BxBlockProfileBio::PreferenceSerializer.new(preference)
        render json: serializer.serializable_hash,
               status: :created
      else
        render json: { errors: [{ preference: preference.errors }] },
               status: :unprocessable_entity
      end
    end

    def load_basic_profile
      @account = AccountBlock::Account.find_by(id: current_user.id)

      if @account.nil?
        render json: {
          message: 'Account not found'
        }, status: :not_found
      end
    end

    def load_preference
      @preference = @account.preference

      if @preference.nil?
        render json: {
          message: 'Preference not found'
        }, status: :not_found
      end
    end
  end
  # rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength, Style/GuardClause, Lint/RescueException, Lint/UselessAssignment
end
