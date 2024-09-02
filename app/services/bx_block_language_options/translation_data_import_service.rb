module BxBlockLanguageOptions
  class TranslationDataImportService
    def store_data(xlsx)
      arr = []
      translations_data = xlsx.sheet("translations_sheet")
      unless translations_data.count > 1
        return {success: false, error: "No data present in translations sheet"}
      end

      success, missing_headers = validate_headers(translations_data.first)
      unless success
        return {success: false, error: "missing headers: #{missing_headers} in translations sheet"}
      end

      translations_data.each(headers) do |row|
        arr << row
      end

      arr[1..].each do |arr2|
        key_error(arr2)
        serial_number_error(sn)

        application_message = BxBlockLanguageOptions::ApplicationMessage.find_or_initialize_by(name: arr2[:key])
        I18n.available_locales.each do |locale|
          if application_message.id.present?
            translation = application_message.translations.find_or_initialize_by(locale: locale.to_s)
            translation.message = arr2[locale].to_s
            unless translation.save
              return {
                success: false,
                error: "Some error occured in Application Message data in row- #{arr2[:sn]} ->" \
                       " #{translation.errors.full_messages} "
              }
            end
          else
            application_message.translations_attributes=  [{message: arr2[locale], locale: locale.to_s}]
          end
          unless application_message.save
            return {
              success: false,
              error: "Some error occured in Application Message data in row- #{arr2[:sn]} ->" \
                     " #{application_message.errors.full_messages} "
            }
          end
        end
      end
      return {success: true}
    end

    private

    def key_error(arr2)
      return {
          success: false,
          error: "key not present in translations sheet"
        } unless arr2[:key].present?
    end

    def serial_number_error(sn)
      return {
          success: false,
          error: "key -#{ arr2[:key] } serial number not present in translations sheet"
        } unless arr2[:sn].present?
    end

    def validate_headers(sheet_headers)
      missing_headers = headers.values - sheet_headers
      [missing_headers.blank?, missing_headers.join(', ')]
    end

    def headers
      available_headers = {sn: 'sn', key: 'key'}
      BxBlockLanguageOptions::Language.pluck(:language_code).each do |language_code|
        available_headers.merge!("#{language_code}": language_code.to_s)
      end
      available_headers
    end
  end
end
