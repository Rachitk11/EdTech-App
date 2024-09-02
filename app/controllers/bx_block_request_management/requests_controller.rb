# frozen_string_literal: true

module BxBlockRequestManagement
  class RequestsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    before_action :load_account
    before_action :find_reviewer_group, only: :create
    before_action :find_request, only: %i[update destroy review]

    def index
      render json: RequestSerializer.new(Request.all).serializable_hash, status: :ok
    end

    def show
      request = Request.find_by(id: params[:id])

      if request.present?
        render json: RequestSerializer.new(request).serializable_hash, status: :ok
      else
        render json: { errors: [{ message: 'Request not found' }] }, status: :not_found
      end
    end

    def sent
      requests = Request.where(sender: @current_account)
      render json: RequestSerializer.new(requests).serializable_hash, status: :ok
    end

    def received
      if @current_account.groups.empty?
        render json: { errors: [{ message: 'Your account is not a part of a group' }] }, status: :not_found and return
      end

      requests = Request.where(account_group: @current_account.groups)
      render json: RequestSerializer.new(requests).serializable_hash, status: :ok
    end

    def create
      if create_request_params[:request_text].blank?
        render json: { errors: "Request text can't be blank" }, status: :unprocessable_entity
      else
        request = Request.new(
          sender: @current_account,
          account_group: @reviewer_group,
          request_text: create_request_params[:request_text]
        )

        if request.save
          render json: RequestSerializer.new(request).serializable_hash, status: :created
        else
          render json: { errors: request.errors }, status: :unprocessable_entity
        end
      end
    end

    def destroy
      return unless check_if_can_review

      if @request.destroy
        render json: RequestSerializer.new(@request).serializable_hash.merge(
          { message: 'Request deleted successfully' }
        ), status: :ok
      end
    end

    def update
      if update_request_params[:request_text].blank?
        render json: { errors: [{ message: 'Request data is blank' }] }, status: :unprocessable_entity and return
      else
        unless @request.sender == @current_account
          render json: { errors: [{ message: 'Cannot update request that is not yours' }] },
                 status: :forbidden and return
        end

        unless @request.status == 'rejected'
          render json: { errors: [{ message: 'Can only update rejected requests' }] },
                 status: :unprocessable_entity and return
        end

        if @request.update(request_text: update_request_params[:request_text], status: :pending, rejection_reason: nil)
          render json: RequestSerializer.new(@request).serializable_hash, status: :ok
        else
          render json: { errors: @request.errors }, status: :unprocessable_entity
        end
      end
    end

    def review
      return unless check_if_can_review

      unless @request.status == 'pending'
        render json: { errors: [{ message: 'Can only review pending requests' }] },
               status: :unprocessable_entity and return
      end

      unless [true, false].include? review_params[:is_accepted]
        render json: { errors: [{ message: 'is_accepted must be either true or false' }] },
               status: :unprocessable_entity and return
      end

      unless review_params[:is_accepted] || review_params[:rejection_reason].present?
        render json: { errors: [{ message: 'Reason for rejection must be given' }] },
               status: :unprocessable_entity and return
      end

      if @request.update(
        status: review_params[:is_accepted] == true ? 'accepted' : 'rejected',
        rejection_reason: review_params[:is_accepted] == true ? nil : review_params[:rejection_reason]
      )
        render json: RequestSerializer.new(@request).serializable_hash, status: :ok
      else
        render json: { errors: @request.errors }, status: :unprocessable_entity
      end
    end

    private

    def create_request_params
      params.require(:data).permit \
        :reviewer_group_id, :request_text
    end

    def update_request_params
      params.require(:data).permit \
        :request_text
    end

    def review_params
      params.permit(:is_accepted, :rejection_reason)
    end

    def find_reviewer_group
      @reviewer_group = BxBlockAccountGroups::Group.find_by(id: create_request_params[:reviewer_group_id])

      render json: { errors: [{ message: 'Reviewer group not found' }] }, status: :not_found if @reviewer_group.nil?
    end

    def find_request
      @request = Request.find_by(id: params[:id])

      render json: { errors: [{ message: 'Request not found' }] }, status: :not_found if @request.nil?
    end

    def check_if_can_review
      if @current_account.groups.empty?
        render json: { errors: [{ message: 'Your account is not a part of a group' }] },
               status: :not_found and return false
      end

      unless @current_account.groups.include?(@request.account_group)
        render json: { errors: [{ message: 'You are not a reviewer of this request' }] },
               status: :forbidden and return false
      end

      true
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def load_account
      @current_account = AccountBlock::Account.find_by(id: @token.id)

      if @current_account.nil?
        render json: { errors: [{ message: "Account with id #{@token.id} doesn't exist" }] }, status: :not_found
      end
    end
  end
end
