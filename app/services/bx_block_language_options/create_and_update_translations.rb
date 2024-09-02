module BxBlockLanguageOptions
  class CreateAndUpdateTranslations
    class << self

      def call
        translations = YAML.load_file(Rails.root.join("config", "locales/en.yml"))
        en_translations = flatten_hash(translations["en"])
        en_translations.each do |key, value|
          application_message = BxBlockLanguageOptions::ApplicationMessage.find_by(name: key)
          unless application_message.present?
            BxBlockLanguageOptions::ApplicationMessage.create(
              name: key, translations_attributes: [ {message: value, locale: "en"} ]
            )
          end
        end
      end

      private
      def flatten_hash(param, prefix=nil)
        param.each_pair.reduce({}) do |a, (k, v)|
          v.is_a?(Hash) ? a.merge(flatten_hash(v, "#{prefix}#{k}.")) : a.merge("#{prefix}#{k}" => v)
        end
      end
    end
  end
end
