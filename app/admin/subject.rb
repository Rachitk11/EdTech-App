ActiveAdmin.register BxBlockCatalogue::Subject, as: "Subject" do
  permit_params :id, :subject_name

  index do
    selectable_column
    id_column
    column :subject_name
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :subject_name
    end
      f.actions
  end

  show title: "Subject" do
    attributes_table do
      row :id
      row :subject_name
    end
  end

end