module BxBlockProfile
  class ChangePhoneValidationsController < ApplicationController
    def create
      validator = ChangePhoneValidator
        .new(@token.id, create_params[:new_phone_number])

      if validator.valid?
        render json: {
          messages: [{
            profile: 'Phone number change is valid',
          }],
        }, status: :created
      else
        errors = validator.errors.full_messages
        render :json => {:errors => [{:profile => errors.first}]},
          :status => :unprocessable_entity
      end
    end

    private

    def create_params
      params.require(:data).permit :new_phone_number
    end
  end
end
