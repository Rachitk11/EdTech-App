module BxBlockDashboardguests
    class CompanySerializer < BuilderBase::BaseSerializer
      attributes :company_name, :company_holder

      attribute :doc do |object, params|
        host = params[:host] || ''
        url = ""
        if object&.doc&.attached?
          url = host + Rails.application.routes.url_helpers.rails_blob_url(
            object.doc, only_path: true)
        end
      end
    end
  end
