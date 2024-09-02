module BxBlockProfile
  class LanguageSerializer < BuilderBase::BaseSerializer
    attributes *[
     :id,
     :language,
     :proficiency,
     :profile_id
    ]
  end
end