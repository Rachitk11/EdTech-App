module BxBlockAppointmentManagement
  class AvailabilitiesController < ApplicationController
    before_action :set_current_user, only: [:create, :destroy]
    before_action :check_service_provider, only: [:index, :destroy]

    def index
      if params[:availability_date].blank?
        render json: {errors: [
          {availability: "Date is an empty."}
        ]}, status: :unprocessable_entity
      else
        availability = Availability.find_by(
          availability_date: Date.parse(params[:availability_date]).strftime("%d/%m/%Y")
        )
        unless availability.present?
          render json: {
            message: "No slots present for date " \
                      "#{Date.parse(params[:availability_date]).strftime("%d/%m/%Y")}"
          } and return
        end
        render json: ServiceProviderAvailabilitySerializer.new(
          availability, meta: {message: "List of all slots"}
        )
      end
    end

    def create
      availability = Availability.new(
        availability_params.merge(service_provider_id: @current_user.id)
      )
      if availability.save
        trigger_slot_worker(availability)
        render json: ServiceProviderAvailabilitySerializer.new(availability), status: 201
      else
        render json: {errors: [{slot_error: availability.errors.full_messages.first}]},
          status: :unprocessable_entity
      end
    end

    def destroy
      availability = BxBlockAppointmentManagement::Availability.find_by(service_provider_id: params[:service_provider_id])
      if availability.destroy
        render json: {message: "Availability deleted successfully"}, status: :ok
      else
        render json: {message: "Availability not found"}, status: 422
      end
    end

    def check_service_provider
      availability = Availability.find_by(service_provider_id: params[:service_provider_id])
      return render json: {message: "Service Provider is not found."}, status: 404 unless availability
    end

    private

    def availability_params
      params.require(:availability).permit(:start_time, :end_time, :availability_date)
    end

    def trigger_slot_worker availability
      BxBlockAppointmentManagement::CreateAvailabilityWorker.perform_async(availability.id)
    end

    def set_current_user
      @current_user = AccountBlock::Account.find(@token.id)
    end
  end
end
