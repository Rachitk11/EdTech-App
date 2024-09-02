module BxBlockAnnotations
  module PatchAccountAnnotationsAssociation
    extend ActiveSupport::Concern

    included do
      has_many :annotations, class_name: 'BxBlockAnnotations::Annotation', foreign_key: 'account_id'
    end
  end
end
