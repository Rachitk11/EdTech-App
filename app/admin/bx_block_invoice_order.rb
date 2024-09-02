module BxBlockInvoiceOrder
end

ActiveAdmin.register BxBlockInvoice::Order, as: "Order_invoice" do
  menu parent: ["Building block invoice"]

  permit_params :order_number, :order_date, :customer_name, :customer_address, :customer_phone_number, :email, :company_id, items_attributes: [:id, :_destroy, :order_id, :item_name, :item_unit_price], bill_to_addresses_attributes: [:name, :company_name, :address, :city, :zip_code, :phone_number, :email, :order_id]

  form do |f|
    f.inputs do
      f.input :company_id, as: :select, include_blank: false, collection: BxBlockInvoice::Company.all
      f.input :order_date
      f.input :customer_name
      f.input :customer_address
      f.input :customer_phone_number
      f.input :email
      f.has_many :items do |item|
        item.input :item_name
        item.input :item_unit_price
      end
      f.has_many :bill_to_addresses do |bill|
        bill.input :name
        bill.input :company_name
        bill.input :address
        bill.input :city
        bill.input :zip_code
        bill.input :phone_number
        bill.input :email
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :order_number
      row :order_date
      row :customer_name
      row :customer_address
      row :customer_phone_number
      row :email
      row :total_amount
      row :company do |object|
        link_to object.company.name, admin_company_path(object.company.id)
      end
      panel "Items" do
        table_for resource.items do
          column "Item ID", &:id
          column :item_unit_price
        end
      end
      panel "Bill to Address" do
        table_for resource.bill_to_addresses do
          column :name
          column :company_name
          column :address
          column :city
          column :zip_code
          column :phone_number
          column :email
        end
      end
    end
  end
end
