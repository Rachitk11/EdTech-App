module BxBlockBulkUploading
  class EbookSerializer < BuilderBase::BaseSerializer
    attributes :title, :author, :size, :pages, :edition, :publisher, :publication_date,:formats_available, :language, :description, :price, :board, :school_class_id, :subject
        
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
  
    attributes :pdf do |object, params|
      if object.pdf.attached?
        host = params[:host] || ''
        url = host + Rails.application.routes.url_helpers.rails_blob_url(object.pdf, only_path: true)
      else
        ''
      end
    end

    attributes :downloads do |object| 
      (object.ebook_allotments.first.download if object.ebook_allotments.present?
          ) || false
    rescue nil
    end

    attributes :date_assigned do |object|
      object.ebook_allotments.first.alloted_date if object.ebook_allotments.present?
    rescue nil
    end

    attributes :status do |object|
      (object.ebook_allotments.first.completed if object.ebook_allotments.present?) || false
    rescue nil
    end
  end
end
   