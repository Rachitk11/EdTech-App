module BxBlockCatalogue
  class CataloguesVariantsController < ApplicationController
    def create
      variant = CatalogueVariant.new(variants_params)
      save_result = variant.save

      if save_result
        render json: CatalogueVariantSerializer.new(
          variant, serialization_options
        ).serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(variant).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def index
      serializer = CatalogueVariantSerializer.new(
        CatalogueVariant.all, serialization_options
      )

      render json: serializer, status: :ok
    end

    def variants_params
      params.permit(:catalogue_id, :catalogue_variant_color_id,
        :catalogue_variant_size_id, :price, :stock_qty, :on_sale,
        :sale_price, :discount_price, :decimal, :length, :breadth,
        :height, :images)
    end

    def serialization_options
      {params: {host: request.protocol + request.host_with_port}}
    end
  end
end
