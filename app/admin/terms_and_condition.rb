ActiveAdmin.register BxBlockTermsAndConditions::TermsAndCondition, as: "Terms And Condition" do
  # actions :all, only: :show, except: [:new, :destroy]
  menu parent: ["Content Management"]
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name do |setting|
        raw(setting.name)
    end
    column :description do |setting|
        raw(setting.description)
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description#, as: :ckeditor
    end
    f.actions
  end

  show do |d|
    attributes_table do 
      row :name do |setting|
        #raw(setting.name)
        setting.name
      end
      row :description do |setting|
        raw(setting.description)
      end
    end
  end
end
