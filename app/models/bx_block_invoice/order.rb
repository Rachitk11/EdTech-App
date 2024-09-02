# frozen_string_literal: true

module BxBlockInvoice
  class Order < BxBlockInvoice::ApplicationRecord
    self.table_name = :bx_block_invoice_orders
    has_many :items, class_name: "BxBlockInvoice::Item", foreign_key: :order_id
    has_many :invoices, class_name: "BxBlockInvoice::Invoice", foreign_key: :order_id
    belongs_to :company, class_name: "BxBlockInvoice::Company", foreign_key: :company_id
    has_many :bill_to_addresses, class_name: "BxBlockInvoice::BillToAddress", foreign_key: :order_id
    accepts_nested_attributes_for :items, allow_destroy: true
    accepts_nested_attributes_for :invoices, allow_destroy: true
    accepts_nested_attributes_for :bill_to_addresses, allow_destroy: true

    after_create :generate_invoice

    def assign_total_amount
      items.pluck(:item_unit_price).compact.sum
    end

    def generate_invoice
      bill_to_addresses.each do |bill_to_address|
        @invoice = invoices.build(
          company_address: company&.address,
          company_city: company&.city,
          company_zip_code: company&.zip_code,
          company_phone_number: company&.phone_number,
          bill_to_name: customer_name,
          bill_to_company_name: bill_to_address.company_name,
          bill_to_address: bill_to_address&.address,
          bill_to_city: bill_to_address&.city,
          bill_to_zip_code: bill_to_address&.zip_code,
          bill_to_phone_number: bill_to_address&.phone_number,
          bill_to_email: bill_to_address&.email, total_amount: assign_total_amount,
          invoice_number: 6.times.map { rand(10) }.join,
          invoice_date: order_date
        )
        @invoice.save
        items = self.items
        items.each do |item|
          @invoice.invoice_items.create(item_id: item.id)
        end
      end
    end
  end
end
