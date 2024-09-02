module BxBlockProfile
  class PublicationPatentsController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")
      if @profile.present?
        @publication_patent = @profile.create_publication_patent(publication_patent_params)
        if @publication_patent.save
          render json: BxBlockProfile::PublicationPatentSerializer.new(@publication_patent
          ).serializable_hash, status: :created
        else
          return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
        end
      end
    end

    def index
      @pp = BxBlockProfile::PublicationPatent.all
      if @pp.present?
        render json: BxBlockProfile::PublicationPatentSerializer.new(@pp, meta: {
        message: "List Of Publication"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def show
      pp = BxBlockProfile::PublicationPatent.find(params[:id])
      if pp.present?
        render json: BxBlockProfile::PublicationPatentSerializer.new(pp, meta: {
        message: "Here are the publication details"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def destroy
      pp = BxBlockProfile::PublicationPatent.find_by(id: params[:id])
      if pp&.destroy
        render json:{ meta: { message: "Publication Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def publication_patent_params
      params.require(:publication_patent).permit \
        :title,
        :publication,
        :authors,
        :url,
        :description,
        :make_public
    end
  end
end