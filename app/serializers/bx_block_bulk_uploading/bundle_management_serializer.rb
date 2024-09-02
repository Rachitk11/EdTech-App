module BxBlockBulkUploading
  class BundleManagementSerializer < BuilderBase::BaseSerializer
    attributes :title, :total_pricing, :books_count, :board, :school_class_id

    attributes :cover_images do |object, params|
      
      if object.cover_images.attached?
        host_url = params[:host] || ''
        image_urls = object.cover_images.map do |image|
          host_url + Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
        end
        image_urls.join(', ') 
      else
        ''
      end
    end
  end
end
