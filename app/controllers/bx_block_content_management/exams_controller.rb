module BxBlockContentManagement
  class ExamsController < ApplicationController
    before_action :assign_exams, only: [:index, :show]
    skip_before_action :validate_json_web_token, only: [:index, :show]

    def index
      filter_exam
      render json: ExamSerializer.new(@exams).serializable_hash, status: :ok
    end

    def show
      @exam = @exams.find_by(id: params[:id])
      render json: ExamSerializer.new(@exam).serializable_hash, status: :ok
    end

    private

    def filter_exam
      params.each do |key, value|
        case key
        when 'date'
          @exams = @exams.where(:to => value["to"].to_date..value["from"].to_date).or(
            @exams.where(:from => value["to"].to_date..value["from"].to_date)
          )
        end
      end
    end

    def assign_exams
      @exams = BxBlockContentManagement::Exam.all
    end
  end
end
