module BxBlockDashboardguests
  class DashboardGuestSerializer < BuilderBase::BaseSerializer
    attributes :company_id, :invest_amount, :date_of_invest
    attribute :company_name do |guest|
      guest.company.company_name
    end

    attribute :doc do |object, params|
      host = params[:host] || ''
      url = ""
      if object&.company.doc&.attached?
        url = host + Rails.application.routes.url_helpers.rails_blob_url(
          object.company.doc, only_path: true)
      end
    end
  end
end
