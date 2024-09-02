module BxBlockCatalogue
  class CataloguesVariantsColorsController < ApplicationController
    def create
      colors = CatalogueVariantColor.new(name: params[:name])
      save_result = colors.save

      if save_result
        render json: CatalogueVariantColorSerializer.new(colors)
          .serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(colors).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def index
      serializer = CatalogueVariantColorSerializer.new(
        CatalogueVariantColor.all
      )

      render json: serializer, status: :ok
    end
  end
end
