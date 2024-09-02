# frozen_string_literal: true

module AccountBlock
  module Accounts
    class EmailConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def show
        begin
          @account = EmailAccount.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {account: "Account Not Found"}
          ]}, status: :unprocessable_entity
        end

        if @account.activated?
          return render json: ValidateAvailableSerializer.new(@account, meta: {
            message: "Account Already Activated"
          }).serializable_hash, status: :ok
        end

        @account.update activated: true

        render json: ValidateAvailableSerializer.new(@account, meta: {
          message: "Account Activated Successfully"
        }).serializable_hash, status: :ok
      end
    end
  end
end
