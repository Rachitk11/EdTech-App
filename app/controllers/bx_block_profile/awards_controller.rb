module BxBlockProfile
  class AwardsController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @awards = BxBlockProfile::Award.new(award_params.merge({profile_id: @profile.id}))

        if @awards.save
          render json: BxBlockProfile::AwardSerializer.new(@awards
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@awards.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def index
      @awards = BxBlockProfile::Award.all
      if @awards.present?
        render json: BxBlockProfile::AwardSerializer.new(@awards, meta: {
        message: "Awards List"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def show
      award = BxBlockProfile::Award.find_by({id: params[:id]})

      if award.present?
        render json: BxBlockProfile::AwardSerializer.new(award, meta: {
        message: "here is the profile with the given id"
      }).serializable_hash, status: :ok

      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def destroy
      award = BxBlockProfile::Award.find_by({id: params[:id]})
      if award&.destroy
        render json:{ meta: { message: "Award Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def award_params
      params.require(:award).permit \
        :title,
        :associated_with,
        :issuer,
        :issue_date,
        :description,
        :make_public
    end
  end
end