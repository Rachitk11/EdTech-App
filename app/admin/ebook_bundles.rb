ActiveAdmin.register BxBlockBulkUploading::BundleManagement, as: "Bundle Management" do
  menu parent: ["User Library"], priority: 2

  permit_params :title, :description, :total_pricing, :board, :school_class_id, :subject, :books_count, cover_images: [], ebook_ids: []

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :total_pricing do |bundle|
      bundle.calculate_revised_price
    end
    column :books_count do |bundle|
      bundle.ebooks.count
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Bundle Details" do
      f.input :title
      f.input :description
      f.input :cover_images, as: :file, input_html: { multiple: true }
      f.input :total_pricing, label: 'Revised Total Pricing', input_html: { readonly: true, value: f.object.calculate_revised_price }
      f.input :board, as: :select, collection: BxBlockCategories::School.distinct.pluck(:board), include_blank: true
      f.input :school_class_id, as: :select, collection: 1..12, include_blank: true
      f.input :subject
      f.inputs "Ebooks" do
        # f.input :ebook_ids, as: :searchable_select, collection: BxBlockBulkUploading::Ebook.all.pluck(:title, :id), include_blank: false, input_html: { multiple: true }
        f.input :ebook_ids, as: :searchable_select, label: 'Ebooks',
                        collection: BxBlockBulkUploading::Ebook.all.pluck(:title, :id), include_blank: true,
                        input_html: { multiple: true,
                        style: 'width: 200px; font-size: 16px; height: 150px;' }
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Cover Images' do |ebook|
        if ebook.cover_images.attached?
          ul do
            ebook.cover_images.each do |image|
              li do
                image_tag(rails_blob_path(image, only_path: true), height: '100')
              end
            end
          end
        else
          'No images'
        end
      end
      row :title
      row :description
      row :board
      row :school_class_id
      row :books_count do |bundle|
        bundle.ebooks.count
      end
      row :total_pricing do |bundle|
        bundle.calculate_revised_price
      end
      row :ebooks do |bundle|
        ul do
          bundle.ebooks.each do |ebook|
            li do
              link_to ebook.title, admin_ebook_path(ebook)
            end
          end
        end
      end
    end
  end
end