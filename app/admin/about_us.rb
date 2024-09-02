ActiveAdmin.register BxBlockContentManagement::AboutUs, as: "About Us" do
  menu parent: ["Content Management"]
  actions :all
  permit_params :title, :description, :email, :phone_number

  index do
    selectable_column
    id_column
    column :email
    column :phone_number
    column :title do |setting|
        raw(setting.title)
    end
    column :description do |setting|
        raw(setting.description)
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :email
      f.input :phone_number
      f.input :title
      f.input :description
    end
    f.actions
  end

  show do |d|
    attributes_table do 
      row :email
      row :phone_number
      row :title do |setting|
        #raw(setting.title)
        setting.title
      end
      row :description do |setting|
        raw(setting.description)
      end
    end
  end
end
