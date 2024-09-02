module BxBlockCatalogue
  class CatalogueVariantSerializer < BuilderBase::BaseSerializer
    attributes :id, :catalogue_id, :catalogue_variant_color_id,
      :catalogue_variant_size_id, :price, :stock_qty, :on_sale,
      :sale_price, :discount_price, :length, :breadth, :height,
      :created_at, :updated_at

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
  end
end
