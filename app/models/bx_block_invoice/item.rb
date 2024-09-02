module BxBlockInvoice
  class Item < ApplicationRecord
    self.table_name = :bx_block_invoice_items
    belongs_to :order, class_name: "BxBlockInvoice::Order", optional: true
  end
end
