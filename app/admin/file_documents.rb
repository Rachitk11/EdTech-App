module FileDocuments; end

ActiveAdmin.register BxBlockDatastorage::FileDocument, as: "Upload File" do
  
    permit_params :title, :description, :document_type, :account_id, attachments: []

    index do 
      selectable_column
      id_column
      column :title
      column :description
      column :document_type
      column :created_at
      column :updated_at
      actions
    end
  
    form do |f|
        f.inputs do
          f.input :title,required: true
          f.input :description,required: true
          f.input :document_type, as: :select
          f.input :account_id, label: "Account", as: :select, collection: AccountBlock::Account.all.map{ |acc| [acc.email, acc.id] }
          f.input :attachments, as: :file, input_html: { multiple: true }
       end
        f.actions
      end
  
    show do
      attributes_table do
        row :title
        row :description
        row :document_type
        row "Document files" do |obj|
           ul do
            if obj.attachments.attached?
              obj.attachments.each do |file|
                li do
                  ENV["HOST"] + Rails.application.routes.url_helpers.rails_blob_path(file, disposition: "attachment", only_path: true)
                end
              end
            end
           end
        end
        row :created_at
        row :updated_at
        # actions
      end
    end
  end