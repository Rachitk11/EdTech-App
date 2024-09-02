module BxBlockProfile
  class TestScoreAndCoursesController < ApplicationController

    def create
      @profile = current_user.profiles.find_by(profile_role:"jobseeker")

      if @profile.present?
        @test_score = BxBlockProfile::TestScoreAndCourse.new(test_score_params.merge({profile_id: @profile.id}))
        if @test_score.save
          render json: BxBlockProfile::TestScoreAndCourseSerializer.new(@test_score
          ).serializable_hash, status: :created
        else
          render json: {
            errors: format_activerecord_errors(@test_score.errors)
          }, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {profile: 'No jobseeker profile exist for this account'},
        ]}, status: :unprocessable_entity
      end
    end

    def index
      @tc = BxBlockProfile::TestScoreAndCourse.all
      if @tc.present?
        render json: BxBlockProfile::TestScoreAndCourseSerializer.new(@tc, meta: {
        message: "List Of Test Score And Courses"
      }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def show
      test_score = BxBlockProfile::TestScoreAndCourse.find_by({id: params[:id]})

      if test_score.present?
        render json: BxBlockProfile::TestScoreAndCourseSerializer.new(test_score, meta: {
          message: "here is the test score for the given id"
        }).serializable_hash, status: :ok
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def destroy
      test_score = BxBlockProfile::TestScoreAndCourse.find_by({id: params[:id]})
      if test_score&.destroy
        render json:{ meta: { message: "Test Score Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def test_score_params
      params.require(:test_score).permit \
        :title,
        :associated_with,
        :score,
        :test_date,
        :description,
        :make_public
    end
  end
end