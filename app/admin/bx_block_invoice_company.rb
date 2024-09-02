module BxBlockInvoiceCompany
end

ActiveAdmin.register BxBlockInvoice::Company, as: "Company" do
  menu parent: ["Building block invoice"]

  permit_params :name, :address, :city, :zip_code, :phone_number, :email

  index do
    selectable_column
    id_column
    column :name
    column :address
    column :city
    column :zip_code
    column :phone_number
    column :email
    actions
  end

  show do
    attributes_table do
      row :name
      row :address
      row :city
      row :zip_code
      row :phone_number
      row :email
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.inputs :name
      f.inputs :address
      f.inputs :city
      f.inputs :zip_code
      f.inputs :phone_number
      f.inputs :email
    end
    f.actions
  end
end
