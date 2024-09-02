module BxBlockCategories
	class SchoolsController < ApplicationController
		skip_before_action :validate_json_web_token, only: [:index]
		def index
			@schools = BxBlockCategories::School.all
			return render json: BxBlockCategories::SchoolSerializer.new(@schools)
		end
	end
end