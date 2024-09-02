module BxBlockElasticsearch
  class EbookSerializer < BuilderBase::BaseSerializer
    attributes :title, :author, :edition, :publisher, :publication_date, :price, :board, :school_class_id, :subject

    attributes :date_downloaded do |object|
      rescue nil
    end

    attributes :status do |object|
      (object.ebook_allotments.first.completed if object.ebook_allotments.present?) || false 
      rescue nil
    end

    attribute :images do |object, params|
      if object.images.attached?
        host = params[:host] || ''
        object.images.map do |image|
          url = host + Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
          { url: url }
        end
      else
        []
      end
    end
  end
end
   