module BxBlockLandingpage2
  class EbookSerializer < BuilderBase::BaseSerializer
    # attributes :title, :author, :edition, :publisher, :publication_date, :price, :board, :school_class_id, :subject

    attributes :ebook_name do |object|
      object&.title 
      rescue nil
    end

    attributes :subject   

    attributes :downloads do |object| 
      (object.ebook_allotments.first.download if object.ebook_allotments.present?) || false
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

    attributes :date_downloaded do |object|
      rescue nil
    end
  end
end
   