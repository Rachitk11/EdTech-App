module BxBlockLogin
  class LoginsController < ApplicationController
    def create
      case params[:data][:type] #### rescue invalid API format
      when 'Student', 'Teacher', 'School Admin', "Publisher"
        account = OpenStruct.new(jsonapi_deserialize(params))
        account.type = params[:data][:type]

        output = AccountAdapter.new

        output.on(:account_not_found) do |account|
          render json: {
            errors: [{
              failed_login: 'Account not found, or not activated',
            }],
          }, status: :unprocessable_entity
        end

        output.on(:Please_enter_valid_student_id_or_account_not_activated) do |account|
          render json: {
            errors: [{
              failed_login: 'Please enter valid student id, or account not activated',
            }],
          }, status: :unprocessable_entity
        end

        output.on(:Account_does_not_exits) do |account|
          render json: {
            errors: [{
              failed_login: 'Account_does_not_exits',

            }],
          }, status: :unprocessable_entity
        end

        output.on(:Please_enter_valid_pin) do |account|
          render json: {
            errors: [{
              failed_login: 'Please enter valid pin',
            }],
          }, status: :unprocessable_entity
        end

        # output.on(:failed_login) do |account|
        #   render json: {
        #     errors: [{
        #       failed_login: 'Login Failed',
        #     }],
        #   }, status: :unauthorized
        # end

        output.on(:successful_login) do |account, token, refresh_token|
          render json: AccountBlock::AccountSerializer.new( account, meta: {
            token: token, refresh_token: refresh_token}).as_json.merge({step: 4, message: "You have successfully login"})
          
        end

        output.login_account(account)
      else
        render json: {
          errors: [{
            account: 'Account not exist.',
          }],
        }, status: :unprocessable_entity
      end
    end
  end
end
