module BxBlockInvoice
end

ActiveAdmin.register BxBlockInvoice::Invoice, as: "Invoice" do
  menu parent: ["Building block invoice"]

  actions :all, except: [:new, :edit]

  permit_params :invoice_number, :invoice_date, :bill_to_customer_name, :bill_to_customer_address, :bill_to_customer_city, :bill_to_customer_zip_code, :bill_to_customer_phone_number, :bill_to_customer_email, invoice_items_attributes: [:id, :item_id, :invoice_id, :_destroy]

  index do
    selectable_column
    id_column
    column :order_id
    column :invoice_number
    column :total_amount
    column :company_zip_code
    column :company_phone_number
    column :bill_to_name
    column :bill_to_company_name
    column :bill_to_zip_code

    actions do |obj|
      host = Rails.env.production? ? ENV["BASE_URL"] : "http://localhost:3000"
      if obj.invoice_pdf.attached?
        item "Download", "#{host}/#{Rails.application.routes.url_helpers.rails_blob_path(obj.invoice_pdf,
          only_path: true)}"
      end
    end
  end

  show do |cs|
    attributes_table do
      row :order_id
      row :invoice_number
      row :invoice_date
      row :total_amount
      row :company_address
      row :company_city
      row :company_zip_code
      row :company_phone_number
      row :bill_to_name
      row :bill_to_company_name
      row :bill_to_address
      row :bill_to_city
      row :bill_to_zip_code
      row :bill_to_phone_number
      row :bill_to_email
      row :item_name
      row :item_unit_price
    end

    panel "Invoice Items" do
      attributes_table_for invoice.invoice_items do
        rows :id
        rows :item_id
        rows :invoice_id
      end
    end
  end

  form do |f|
    f.inputs do
      f.inputs "Invoice Items" do
        f.has_many :invoice_items, heading: false, allow_destroy: true do |cd|
          cd.input :id
          cd.input :item_id
          cd.input :invoice_id
        end
      end
    end
    actions
  end
end
