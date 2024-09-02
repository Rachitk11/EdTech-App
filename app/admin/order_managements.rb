ActiveAdmin.register BxBlockOrderManagement::Order, as: "All Orders" do
  menu parent: ["Order Management"]
  actions :all, except: [:new, :edit, :destroy]

  permit_params :order_number, :amount, :status, :account_id, :total_tax, :order_status_id, :tax_charges, :confirmed_at, :cancelled_at, :placed_at, :order_date, :total
  
  index do
    selectable_column
    id_column
    column :order_number
    column :amount
    column :status
    column :account_id
    column :order_status_id
    column :order_date
    actions
  end

  show do
    attributes_table do
      row :order_number
      row :amount
      row :status
      row :account_id
      row :order_status_id
      row :order_date
      row :tax_charges
      row :total_tax
      row :confirmed_at
      row :cancelled_at
      row :placed_at
      row :total
    end

    panel "Order Items" do
      table_for resource.order_items do
        column :id
        column :quantity
        column :unit_price
        column :ebook_id
        column :bundle_management_id
        column :total_price
        column :status
        column :order_status_id
        column :refunded_at
      end
    end
    active_admin_comments
  end
end
