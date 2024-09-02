module BxBlockTermsAndConditions
  class TermsAndConditionsController < ApplicationController
    before_action :validate_json_web_token, :current_user, only: [:accept_and_reject]

    # def create
    #   term = BxBlockTermsAndConditions::TermsAndCondition.new(terms_and_condition_params
    #     .merge(account_id: current_user.id))
    #   if term.save
    #     render json: {data: {id: term.id}}, status: :created
    #   else
    #     render json: {errors: term.errors}, status: :unprocessable_entity
    #   end
    # end

    # def index
    #   terms = BxBlockTermsAndConditions::TermsAndCondition.all.select(:id, :created_at, :description)
    #   if terms.present?
    #     render json: {data: terms}, status: :ok
    #   else
    #     render json: {message: "terms and conditions data not found"}, status: :not_found
    #   end
    # end

    def show
      term = BxBlockTermsAndConditions::TermsAndCondition.last
      if term.present?
        render json: TermsAndConditionsSerializer.new(term)
          .serializable_hash, status: :ok
      else
        render json: {message: "terms and conditions data not found"}, status: :not_found
      end
    end

    def latest_record
      account = AccountBlock::Account.find(params[:id])
      term = BxBlockTermsAndConditions::TermsAndCondition.last
      if term.present? && account.present?
        user_term = BxBlockTermsAndConditions::UserTermAndCondition.find_or_create_by(terms_and_condition_id: term.id, account_id: account.id)
        if update_params[:is_accepted] == "true"
          if user_term.present?
            user_term.update(is_accepted: update_params[:is_accepted], account_id: account.id)
            render json: {data: {user_term: user_term }, message: "Terms and Conditions retrieved successfully!"}.as_json.merge({step: 3}), status: :ok
          else
            user_term = BxBlockTermsAndConditions::UserTermAndCondition.create(terms_and_condition_id: term.id, account_id: account.id, is_accepted: update_params[:is_accepted])
            render json: {data: {user_term: user_term }, message: "Terms and Conditions retrieved successfully!"}.as_json.merge({step: 3}), status: :created
          end
        else
          render json: {message: "Please accept terms and condition to move ahead"}, status: :unprocessable_entity
        end
      else
        render json: {message: "terms and conditions data not found"}, status: :not_found
      end
    end

    def accept_and_reject
      term = BxBlockTermsAndConditions::TermsAndCondition.last
      if term.present?
        @user_term = BxBlockTermsAndConditions::UserTermAndCondition.find_or_create_by(terms_and_condition_id: term.id)
        if update_params[:is_accepted] == "true" || update_params[:is_accepted] == "false"
          if @user_term.present?
            @user_term.update(is_accepted: update_params[:is_accepted], account_id: current_user.id)
          else
            @user_term = BxBlockTermsAndConditions::UserTermAndCondition.create!(terms_and_condition_id: term.id, account_id: current_user.id, is_accepted: update_params[:is_accepted])
          end
          render json: @user_term, status: :created
        else
          render json: {message: "is_accepted should be either true or false."}, status: :unprocessable_entity
        end
      else
        render json: {message: "Terms and Condition not found"}, status: :not_found
      end
    end

    private

    # def check_admin
    #   if admin_auth.eql?("true") || account_auth.eql?("true")
    #     true
    #   else
    #     render json: {message: "You are not authorised user or proper role admin"}, status: :unauthorized
    #   end
    # end

    # def check_basic
    #   if account_auth.eql?("true")
    #     true
    #   else
    #     render json: {message: "You are not authorised user or proper role basic"}, status: :unauthorized
    #   end
    # end


    # def invalid_id?(id)
    #   id <= 0 || !id.present? ? true : false
    # end

    # def terms_and_condition_params
    #   params.require(:terms_and_condition).permit(:description)
    # end

    def update_params
      params.require(:data).permit(:is_accepted)
    end
  end
end
