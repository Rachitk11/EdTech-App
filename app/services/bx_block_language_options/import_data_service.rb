require 'roo'

module BxBlockLanguageOptions
  class ImportDataService
    class << self

      def store_data(file_obj_path)
        xlsx = Roo::Spreadsheet.open(file_obj_path)
        sheets_name_arr = xlsx.sheets
        unless sheets_name_arr.include?("translations_sheet")
          return {success: false, error: "Please add translations sheet"}
        end
        ActiveRecord::Base.transaction do
          @response = BxBlockLanguageOptions::TranslationDataImportService.new.store_data(xlsx)
          unless @response[:success]
            raise ActiveRecord::Rollback
          end
        end
        return @response
      end

    end
  end
end
