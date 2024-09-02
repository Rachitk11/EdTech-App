module BxBlockProfile
  class HobbySerializer < BuilderBase::BaseSerializer
    attributes *[
      :title,
      :category,
      :description,
      :make_public
    ]
  end
end