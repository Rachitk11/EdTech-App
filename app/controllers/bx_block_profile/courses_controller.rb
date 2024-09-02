module BxBlockProfile
  class CoursesController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @courses = BxBlockProfile::Course.new(courses_params.merge({profile_id: @profile.id}))
        if @courses.save
          render json: BxBlockProfile::CourseSerializer.new(@courses
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@courses.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def index
      @courses = BxBlockProfile::Course.all
      if @courses.present?
        render json: BxBlockProfile::CourseSerializer.new(@courses, meta: {
        message: "Courses List"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def show
      course = BxBlockProfile::Course.find_by({id: params[:id]})
      if course.present?
        render json: BxBlockProfile::CourseSerializer.new(course, meta: {
          message: "here is the course with the given id"
        }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def destroy
      course = BxBlockProfile::Course.find_by({id: params[:id]})
      if course&.destroy
        render json:{ meta: { message: "Course Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end
    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def courses_params
      params.require(:courses).permit \
        :course_name,
        :duration,
        :year
    end
  end
end
