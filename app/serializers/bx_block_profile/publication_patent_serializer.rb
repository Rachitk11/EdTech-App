module BxBlockProfile
  class PublicationPatentSerializer < BuilderBase::BaseSerializer
    attributes *[
      :title,
      :publication,
      :authors,
      :url,
      :description,
      :make_public,
      :profile_id
    ]
  end
end