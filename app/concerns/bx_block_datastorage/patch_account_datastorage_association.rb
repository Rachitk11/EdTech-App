module BxBlockDatastorage
  module PatchAccountDatastorageAssociation
    extend ActiveSupport::Concern

    included do
      has_many :file_documents, class_name: "BxBlockDatastorage::FileDocument", dependent: :destroy
    end
  end
end
