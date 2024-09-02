module BxBlockAnnotations
  class AnnotationSerializer < BuilderBase::BaseSerializer

    attributes *[
      :title,
      :description,
      :account
    ]
  end
end
