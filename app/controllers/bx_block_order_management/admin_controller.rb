# frozen_string_literal: true

module BxBlockOrderManagement
  class AdminController < BxBlockOrderManagement::ApplicationController
    before_action :verify_admin_token

    def delivery_address_create
      da = BxBlockOrderManagement::DeliveryAddress.create(
        delivery_address_params
      )
      render json: {delivery_address: da} if da.save
    end

    private

    def delivery_address_params
      params.require(:delivery_address).permit(
        :account_id, :address, :address_line_2, :address_type, :address_for,
        :name, :flat_no, :zip_code, :phone_number, :latitude, :longitude,
        :residential, :city, :state_code, :country_code, :state, :country,
        :is_default, :landmark
      )
    end

    def verify_admin_token
      render json: {error: "Invalid admin token"} unless request.headers[:admintoken] == ENV["ADMIN_API_TOKEN"]
    end
  end
end
