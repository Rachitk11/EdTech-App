module BxBlockCatalogue
  class BrandsController < ApplicationController
    def create
      brand = Brand.new(brand_params)
      save_result = brand.save

      if save_result
        render json: BrandSerializer.new(brand).serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(brand).serializable_hash,
          status: :unprocessable_entity
      end
    rescue ArgumentError
      render json: { message: "Please Enter Valid Currency From List", Currencies: Brand.currencies.keys }
    end

    def index
      serializer = BrandSerializer.new(Brand.all)

      render json: serializer, status: :ok
    end

    private

    def brand_params
      params.require(:brand).permit(:name, :currency)
    end
  end
end
