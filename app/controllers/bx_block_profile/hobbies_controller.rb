module BxBlockProfile
  class HobbiesController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @hobbies = BxBlockProfile::Hobby.new(hobbies_params.merge({profile_id: @profile.id}))
        if @hobbies.save
          render json: BxBlockProfile::HobbySerializer.new(@hobbies
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@hobbies.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def index
      @hobbies = BxBlockProfile::Hobby.all
      if @hobbies.present?
        render json: BxBlockProfile::HobbySerializer.new(@hobbies, meta: {
        message: "Hobbies List"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def show
      hobby = BxBlockProfile::Hobby.find_by({id: params[:id]})
      if hobby.present?
        render json: BxBlockProfile::HobbySerializer.new(hobby, meta: {
          message: "here is the hobby with the given id"
        }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def destroy
      hobby = BxBlockProfile::Hobby.find_by({id: params[:id]})
      if hobby&.destroy
        render json:{ meta: { message: "Hobyy Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end
    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def hobbies_params
      params.require(:hobbies).permit \
        :title,
        :category,
        :description,
        :make_public
    end
  end
end