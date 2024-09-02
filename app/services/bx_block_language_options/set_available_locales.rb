# BxBlockLanguageOptions::SetAvailableLocales.call
module BxBlockLanguageOptions
  class SetAvailableLocales
    class << self
      def call
        language_codes = [I18n.default_locale.to_s]
        language_codes.push(
          *BxBlockLanguageOptions::Language.pluck(:language_code).compact
        ) if BxBlockLanguageOptions::Language.table_exists? rescue false
        I18n.available_locales = language_codes.uniq
      end
    end
  end
end
