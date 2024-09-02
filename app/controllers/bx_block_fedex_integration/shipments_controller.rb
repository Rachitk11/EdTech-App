module BxBlockFedexIntegration
  class ShipmentsController < ApplicationController
    def create
      shipment_params = jsonapi_deserialize(params)
      create_shipment = CreateShipment.new(shipment_params)

      if create_shipment.save
        render json: { shipment: CreateShipmentSerializer.new(create_shipment).serializable_hash }, status: :created
      else
        render json: response, status: :unprocessable_entity
      end
    end

    def show
      shipment = CreateShipment.find(params[:id])

      if shipment.present?
        render json: { shipment: CreateShipmentSerializer.new(shipment).serializable_hash }, status: :ok
      else
        render json: shipment, status: :not_found
      end
    end
  end
end
