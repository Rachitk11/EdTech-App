module BxBlockLanguageOptions
  class LanguageSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :language_code, :created_at, :updated_at
  end
end
