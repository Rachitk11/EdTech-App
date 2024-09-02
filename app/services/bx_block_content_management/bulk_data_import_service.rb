module BxBlockContentManagement
  class BulkDataImportService
    def store_data(xlsx, current_user_id)
      error_tracker = ErrorTracker.new

      BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)
      BxBlockContentManagement::SubCategoryImportService.call(xlsx, error_tracker)
      BxBlockContentManagement::ContentImportService.call(xlsx, error_tracker, current_user_id)
      BxBlockContentManagement::PartnerImportService.call(xlsx, error_tracker)

      if error_tracker.success?
        return {success: true}
      else
        return {success: false, errors: error_tracker.get_errors}
      end
    end
  end
end
