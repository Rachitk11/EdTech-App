module BxBlockDashboardguests
    class CompaniesController < ApplicationController
      skip_before_action :validate_json_web_token, only: [:show, :index]
      before_action :load_company, only: [:show, :update, :destroy]

      def index
        companies = Company.all
        render json: CompanySerializer.new(companies, params: { host: request.protocol + request.host_with_port }), status: :ok
      end
  
      def create
        @company = Company.new(company_params)
        user = AccountBlock::Account.find(@token.id)
        @company.company_holder = user&.full_name.present? ? user&.full_name : " "
        if @company.save
          render json: CompanySerializer.new(@company, params: { host: request.protocol + request.host_with_port }).serializable_hash, status: :created
        else
          render json: {'errors' => [@company.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end
  
      def show
        render json: CompanySerializer.new(@company, params: { host: request.protocol + request.host_with_port }).serializable_hash, status: :ok
      end
  
      def destroy
        @company.destroy
        render json: { success: true }, status: :ok
      end
  
      def update
        if @company.update(company_params)
          render json: CompanySerializer.new(@company, params: { host: request.protocol + request.host_with_port }), status: :ok
        else
          render json: {'errors' => [@company.errors.full_messages.to_sentence]}, status: :unprocessable_entity
        end
      end

      private

      def load_company
        @company = Company.find_by(id: params[:id])
        if @company.nil?
          return render json: {
              message: "Company with id #{params[:id]} doesn't exists"
          }, status: :not_found
        end
      end

      def company_params
        params.require(:data).permit(:company_name, :doc)
      end
    end
  end
