ActiveAdmin.register BxBlockContentManagement::FaqQuestion, as: "FAQ" do
  menu parent: ["Content Management"]
  actions :all
  # menu :priority => 2
  permit_params :question, :answer

  index do
    selectable_column
    id_column
    column :question do |setting|
        raw(setting.question)
    end
    column :answer do |setting|
        raw(setting.answer)
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :question
      f.input :answer
    end
    f.actions
  end

  show do |d|
    attributes_table do 
      row :question do |setting|
        #raw(setting.question)
        setting.question
      end
      row :answer do |setting|
        raw(setting.answer)
      end
    end
  end
end
