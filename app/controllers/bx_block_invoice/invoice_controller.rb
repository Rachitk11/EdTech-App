module BxBlockInvoice
  class InvoiceController < BxBlockInvoice::ApplicationController
    skip_before_action :validate_json_web_token, only: [:invoice_pdf, :generate_invoice_pdf]
    before_action :fetch_invoice, only: %i[generate_invoice_pdf invoice_pdf]

    def generate_invoice_pdf
      host = "#{request.protocol}#{request.host_with_port}"

      render json: {invoice: "#{host}/#{Rails.application.routes.url_helpers.rails_blob_path(@invoice.invoice_pdf,
        only_path: true)}"}
    end

    private

    def fetch_invoice
      @invoice = Invoice.find_by(invoice_number: params[:invoice_number].to_s)
      return render json: {errors: [{message: "No invoice found."}]}, status: :not_found unless @invoice
    end
  end
end
