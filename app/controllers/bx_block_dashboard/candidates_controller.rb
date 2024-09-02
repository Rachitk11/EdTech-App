module BxBlockDashboard
	class CandidatesController < BxBlockDashboard::ApplicationController
		def index
			@candidate = BxBlockDashboard::Candidate.last
			total_count = BxBlockDashboard::Candidate.count
 			render json: BxBlockDashboard::CandidateSerializer.new(@candidate, params: { total_candidates: total_count }) , status: :ok
		end

		def create 
			@candidate = BxBlockDashboard::Candidate.new(candidate_params)
			if @candidate.save
        render json: BxBlockDashboard::CandidateSerializer.new(@candidate), status: :created
      else
        render json: { errors: @candidate.errors }, status: :unprocessable_entity
      end
    end

			private

    	def candidate_params
      	params.require(:candidate).permit(:name,:email,:address)
    	end
	 	end
 end