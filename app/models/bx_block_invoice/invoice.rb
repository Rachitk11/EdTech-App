module BxBlockInvoice
  class Invoice < ApplicationRecord
    self.table_name = :bx_block_invoice_invoices
    belongs_to :order, class_name: "BxBlockInvoice::Order"
    has_many :invoice_items, class_name: "BxBlockInvoice::InvoiceItem", foreign_key: :invoice_id
    has_one_attached :invoice_pdf
    before_save :generate_pdf

    def generate_pdf
      html = ActionController::Base.new.render_to_string(template: "bx_block_invoices/generate_invoice_pdf.html.erb",
        orientation: "Landscape", page_size: "Letter", formats: :pdf, background: true, locals: {invoice: self})
      pdf = WickedPdf.new.pdf_from_string(html, filename: "Invoice_#{invoice_number}.pdf",
        type: "application/pdf")
      invoice_pdf.attach(io: StringIO.new(pdf), filename: "Invoice_#{invoice_number}.pdf",
        content_type: "application/pdf")
    end
  end
end
