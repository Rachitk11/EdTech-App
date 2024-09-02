module BxBlockLanguageOptions
  class TranslationSerializer < BuilderBase::BaseSerializer
    attributes :locale, :message
  end
end
