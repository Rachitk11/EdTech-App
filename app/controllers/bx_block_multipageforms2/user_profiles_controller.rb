module BxBlockMultipageforms2
	class UserProfilesController < ApplicationController
		def index
			profiles = UserProfile.all
	      if profiles.present?
	        render json: UserProfileSerializer.new(profiles).serializable_hash
	      else
	        render json: {data: []},
	            status: :ok
	      end
		end

		def show
			profile = UserProfile.find_by(id: params[:id])

      	return render json: {errors: [
          {profile: 'Not found'},
        	]}, status: :not_found if profile.blank?
      	json_data = UserProfileSerializer.new(profile).serializable_hash
      	render json: json_data
		end


		def create
			profile = UserProfile.new(profile_params)
	      if profile.save
	         render json: UserProfileSerializer.new(profile).serializable_hash,
	         status: :ok
	      else
	        render json: {message: "Something went wrong"},
	               status: :unprocessable_entity
	      end
		end

		def update
			profile = UserProfile.find_by(id: params[:id])

	      return render json: {errors: [
	          {UserProfile: 'Not found'},
	        ]}, status: :not_found if profile.blank?

	      update_profile = profile.update(profile_params)

	      if update_profile == true
	         render json: UserProfileSerializer.new(profile).serializable_hash
	      else
	        render json: {errors: format_activerecord_errors(profile.errors)},
	            status: :unprocessable_entity
	      end
		end

		def destroy
			profile = UserProfile.find_by(id: params[:id])
	      return if profile.nil?
	      if profile.destroy
	        render json: {message: "Profile deleted succesfully!"}, status: :ok
	      else
	        render json: {message: "Something went wrong"}.serializable_hash,
	               status: :unprocessable_entity
	      end
		end

		private
		def format_activerecord_errors(errors)
	      result = []
	      errors.each do |attribute, error|
	        result << { attribute => error }
	      end
	      result
	    end

		def profile_params
	      params.require(:data)[:attributes].permit(
	        :first_name, :last_name, :phone_number, :email, :gender,
	        :country, :industry, :message
	      )
	    end

	end
end
