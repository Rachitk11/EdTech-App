module BxBlockAnalytics7
  class SchoolAdminAnalyticsController < ApplicationController
  	before_action :validate_json_web_token, :current_user

    def get_all_data
    	if current_user.present?
    		if current_user.role.name == "School Admin"
    			@school = current_user.school
    			@all_teachers = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), school_id: @school.id).count
		    	@all_students = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Student"), school_id: @school.id).count
		    	@all_publishers = AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"}).size
		    	@all_ebooks = BxBlockBulkUploading::Ebook.all.count
		    	@all_videos = BxBlockCatalogue::VideosLecture.where(school_id: @school.id).count
		    	@all_assignments = BxBlockCatalogue::Assignment.where(school_id: @school.id).count
		    	total_contents = {ebooks: @all_ebooks, videos: @all_videos, assignments: @all_assignments}
		    	data = {students: @all_students, teachers: @all_teachers, publishers: @all_publishers}
		    	render json: {data: data, total_contents: total_contents, success: true}, status: :ok
		    else
		    	render json: {message: "Invalid User!"}, status: :unprocessable_entity
		    end
		  else
		  	render json: {message: "User Not Found!"}, status: :not_found
		  end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end
  end
end
