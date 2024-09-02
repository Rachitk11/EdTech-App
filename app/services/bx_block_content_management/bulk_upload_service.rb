require 'roo'

module BxBlockContentManagement
  class BulkUploadService
    class << self

      def store_data(file_obj_path, current_user_id)
        xlsx = Roo::Spreadsheet.open(file_obj_path)
        sheets_name_arr = xlsx.sheets
        ActiveRecord::Base.transaction do
          @response = BxBlockContentManagement::BulkDataImportService.new.store_data(xlsx, current_user_id)
          unless @response[:success]
            @response
            raise ActiveRecord::Rollback
          end
        end
        return @response
      end
    end
  end
end
