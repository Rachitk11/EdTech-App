module BxBlockProfile
  class PasswordsController < ApplicationController
    before_action :validate_json_web_token

    def reset_password
      if params[:data][:pin] != params[:data][:confirm_pin]
        return render json: {message: "confirm pin is wrong"}
      end
      @account = AccountBlock::Account.find(@token.id)
      render json: {errors: "Record not found"} unless @account.present?
      if @account.update(pin: params[:data][:pin], is_reset: false, one_time_pin: "")
        render json: AccountBlock::AccountSerializer.new(@account).serializable_hash, status: :ok
      end
    end

    # def update
    #   status, result = ChangePasswordCommand.execute \
    #     @token.id,
    #     update_params[:current_password],
    #     update_params[:new_password]

    #   if status == :created
    #     serializer = AccountBlock::AccountSerializer.new(result)
    #     render :json => serializer.serializable_hash,
    #       :status => :created
    #   else
    #     render :json => {:errors => [{:profile => result.first}]},
    #       :status => status
    #   end
    # end

    private

    # def update_params
    #   params.require(:data)
    #     .permit \
    #     :current_password,
    #     :new_password
    # end
  end
end
