module BxBlockLanguageOptions
  class ApplicationMessageSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at

    attribute :translations do |object|
      TranslationSerializer.new(object.translations)
    end

  end
end
