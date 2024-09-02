module BxBlockCatalogue
  class CatalogueSerializer < BuilderBase::BaseSerializer
    attributes :sub_category, :brand, :tags, :reviews,
      :name, :sku, :description, :manufacture_date,
      :length, :breadth, :height, :stock_qty,
      :availability, :weight, :price, :recommended,
      :on_sale, :sale_price, :discount

    attribute :category do |object, params|
      object.category &&
        BxBlockCategories::CategorySerializer.new(object.category, params: params).serializable_hash[:data]
    end

    attribute :images do |object, params|
      host = params[:host] || ""

      if object.images.attached?
        object.images.map { |image|
          {
            id: image.id,
            url: host + Rails.application.routes.url_helpers.rails_blob_url(
              image, only_path: true
            )
          }
        }
      end
    end

    attribute :average_rating, &:average_rating

    attribute :catalogue_variants do |object, params|
      serializer = CatalogueVariantSerializer.new(
        object.catalogue_variants, {params: params}
      )
      serializer.serializable_hash[:data]
    end
  end
end
