module BxBlockContentManagement
  class EpubSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :files, :description, :created_at, :updated_at
    attributes :files do |object|
      if object.pdfs.present?
        object.pdfs.each do |pdf|
          pdf.pdf_url if pdf.present?
        end
      else
        []
      end
    end
  end
end
