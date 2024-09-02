module BxBlockDatastorage
  class FileDocumentSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :title,
      :description,
      :document_type,
      :created_at,
      :updated_at
    ]

    attribute :attachments do |obj|
      obj.document_file_url
    end

    attribute :account do |object|
      object.account
    end
  end
end
