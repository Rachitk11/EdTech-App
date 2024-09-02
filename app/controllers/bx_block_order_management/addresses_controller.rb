# frozen_string_literal: true

module BxBlockOrderManagement
  class AddressesController < BxBlockOrderManagement::ApplicationController
    before_action :current_user
    before_action :render_address_not_found, unless: :address_found?, only: [:show, :destroy, :update]

    def index
      addresses = user_delivery_addresses
      if addresses.present?
        render json: AddressesSerializer.new(addresses).serializable_hash,
          status: :ok
      else
        render json: {message: "No addresses exist"}, status: 404
      end
    end

    def create
      delivery_address = DeliveryAddress.new(
        address_params.merge({account_id: @current_user.id})
      )
      delivery_address.is_default = true if user_delivery_addresses.blank?
      delivery_address.save!
      if delivery_address.is_default
        DeliveryAddress.rest_addresses(delivery_address.id).where(
          account_id: @current_user.id
        ).update_all(is_default: false)
      end
      render json: AddressesSerializer.new(delivery_address, serialize_options).serializable_hash,
        message: "Address added successfully ", status: :ok
    end

    def show
      render json: AddressesSerializer.new(@delivery_address, serialize_options).serializable_hash,
        status: :ok
    end

    def destroy
      @delivery_address.destroy

      if @delivery_address.destroyed?
        render json: {message: "Address deleted successfully"}, status: :ok
      else
        render json: "Address ID does not exist", status: 404
      end
    end

    def update
      begin
        ActiveRecord::Base.transaction do
          @delivery_address.update!(address_params)
          if @delivery_address.is_default
            DeliveryAddress.rest_addresses(@delivery_address.id).where(
              account_id: @current_user.id
            ).update_all(is_default: false)
          end
        end
      rescue => e
        render json: {error: e.message}
        return
      end
      render json: AddressesSerializer.new(@delivery_address, serialize_options).serializable_hash,
        message: "Address updated successfully ", status: :ok
    end

    private

    def render_address_not_found
      render json: {message: "Address ID does not exist"}, status: 404
    end

    def user_delivery_addresses
      @user_delivery_addresses ||= DeliveryAddress.where(account_id: @current_user.id)
    end

    def address_params
      params.permit(
        :name, :flat_no, :address_type, :address, :address_line_2, :zip_code, :phone_number,
        :latitude, :longitude, :is_default, :state, :country, :city, :landmark, :address_for
      )
    end

    def fetch_address
      @delivery_address ||= DeliveryAddress.find_by(account_id: @current_user.id, id: params[:id])
    end

    def address_found?
      fetch_address && @delivery_address
    end

    def serialize_options
      {params: {user: @current_user}}
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Naming/VariableNumber, Naming/MemoizedInstanceVariableName
