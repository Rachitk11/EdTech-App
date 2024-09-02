module BxBlockCatalogue
  class CataloguesController < ApplicationController
    before_action :load_catalogue, only: %i[show update destroy]

    def create
      catalogue = Catalogue.new(catalogue_params)
      save_result = catalogue.save

      if save_result
        process_images(catalogue, params[:images])

        catalogue.tags << Tag.where(id: params[:tags_id])

        process_variants_images(catalogue)

        render json: CatalogueSerializer.new(catalogue, serialization_options)
          .serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(catalogue).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def show
      return if @catalogue.nil?

      render json: CatalogueSerializer.new(@catalogue, serialization_options)
        .serializable_hash,
        status: :ok
    end

    def index
      catalogues = Catalogue.all
      serializer = CatalogueSerializer.new(catalogues, serialization_options)

      render json: serializer, status: :ok
    end

    def destroy
      return if @catalogue.nil?

      if @catalogue.destroy
        render json: {success: true}, status: :ok
      else
        render json: ErrorSerializer.new(@catalogue).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def update
      return if @catalogue.nil?

      update_result = @catalogue.update(catalogue_params)

      update_tags
      process_images(@catalogue, params[:images])
      process_variants_images(@catalogue)

      if update_result
        render json: CatalogueSerializer.new(@catalogue, serialization_options)
          .serializable_hash,
          status: :ok
      else
        render json: ErrorSerializer.new(@catalogue).serializable_hash,
          status: :unprocessable_entity
      end
    end

    private

    def load_catalogue
      @catalogue = Catalogue.find_by(id: params[:id])

      if @catalogue.nil?
        render json: {
          message: "Catalogue with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def catalogue_params
      params.permit(:category_id, :sub_category_id, :brand_id,
        :name, :sku, :description, :manufacture_date, :length,
        :breadth, :height, :stock_qty, :availability, :weight,
        :price, :recommended, :on_sale, :sale_price, :discount,
        catalogue_variants_attributes:
            %i[id catalogue_variant_color_id
              catalogue_variant_size_id price stock_qty
              on_sale sale_price discount_price length breadth
              height _destroy])
    end

    def update_tags
      tags = @catalogue.tags

      existing_tags_id = tags.map(&:id)
      params_tags = params[:tags_id] || []

      remove_ids = existing_tags_id - params_tags
      if remove_ids.size.positive?
        @catalogue.tags.delete(Tag.where(id: remove_ids))
      end

      add_ids = params_tags - existing_tags_id
      if add_ids.size.positive?
        @catalogue.tags << Tag.where(id: add_ids)
      end
    end

    def process_images(imagable, images_params)
      return unless images_params.present?

      images_to_attach = []
      images_to_remove = []

      images_params.each do |image_data|
        if image_data[:id].present? &&
            (image_data[:remove].present? || image_data[:data].present?)
          images_to_remove << image_data[:id]
        end

        if image_data[:data]
          images_to_attach.push(
            io: StringIO.new(Base64.decode64(image_data[:data])),
            content_type: image_data[:content_type],
            filename: image_data[:filename]
          )
        end
      end

      imagable.images.where(id: images_to_remove).purge if
          images_to_remove.size.positive?
      imagable.images.attach(images_to_attach) if
          images_to_attach.size.positive?
    end

    def process_variants_images(catalogue)
      variants = params[:catalogue_variants_attributes]

      return unless variants.present?

      variants.each_with_index do |v, index|
        next unless v[:images].present?

        process_images(catalogue.catalogue_variants[index], v[:images])
      end
    end

    def serialization_options
      {params: {host: request.protocol + request.host_with_port}}
    end
  end
end
