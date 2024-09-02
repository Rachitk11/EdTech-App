module BxBlockLanguageOptions
  class BuildLanguages
    class << self

      def call(languages = languages_array)
        languages.each do |language|
          BxBlockLanguageOptions::Language.where(
            'lower(name) = ?', language[:name].downcase
          ).first_or_create(name: language[:name], language_code: language[:language_code])
        end
      end

      private

      def languages_array
        [
          {name: "Hindi", language_code: "hi"},
          {name: "English", language_code: "en"},
          {name: "Telugu", language_code: "te"},
          {name: "Tamil", language_code: "ta"},
          {name: "Marathi", language_code: "mr"},
          {name: "Bangla", language_code: "bn"},
          {name: "Gujarati", language_code: "gu"},
          {name: "Oriya", language_code: "or"}
        ]
      end

    end
  end
end
