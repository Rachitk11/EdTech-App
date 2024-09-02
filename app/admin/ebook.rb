require 'pdf/reader'
require 'open-uri'
ActiveAdmin.register BxBlockBulkUploading::Ebook, as: "Ebook" do
  menu parent: ["User Library"], priority: 1
  actions :all
  permit_params :title, :author, :size, :pages, :edition, :publisher, :publication_date, :formats_available, :language, :description, :price, :commission_percentage, :board, :school_class_id, :subject, :excel_file, :pdf, images: []

  collection_action :download_sample_excel, method: :get
  member_action :download_error_excel, method: :get
  current_year = Time.now.year

  filter :school_class_id, as: :select, collection: (1..12).to_a, label: "Class"
  # filter :board, as: :select, collection: BxBlockCategories::School.distinct.pluck(:board), label: "Board"
  filter :subject

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :edition
    column :price
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :author
      row :size do |ebook|
        if ebook.pdf.attached?
          pdf_size = ebook.pdf.blob.byte_size
          "PDF Size: #{number_to_human_size(pdf_size)}"
        else
          "No PDF available."
        end
      end
      row :pages do |ebook|
        if ebook.pdf.attached?
          begin
            pdf_data = ebook.pdf.download.force_encoding('BINARY')
            pdf_info = PDF::Reader.new(StringIO.new(pdf_data))
            "Pages: #{pdf_info.pages.count}"
          rescue PDF::Reader::MalformedPDFError => e
            "Error reading PDF: #{e.message}"
          end
        else
          "No PDF available."
        end
      end
      row :edition
      row :publisher
      # row :publisher do |ebook|
      #   begin
      #     Rails.logger.debug("Ebook Publisher ID: #{ebook.publisher}")
      #     publisher_id = ebook.publisher
      #     if publisher_id.present?
      #       publisher = AccountBlock::Account.find_by(id: publisher_id)
      #       Rails.logger.debug("Found Publisher: #{publisher.publication_house_name}") if publisher
      #       "#{publisher.publication_house_name}" if publisher
      #     else
      #       "Publisher ID not present"
      #     end
      #   rescue ActiveRecord::RecordNotFound
      #     Rails.logger.debug("Publisher not found")
      #     "Publisher not found"
      #   end
      # end
      row :publication_date
      row :formats_available
      row :language
      row :description
      row :price
      row :commission_percentage
      row :board
      row :school_class_id
      row :subject
      row :pdf do |ebook|
        if ebook.pdf.attached?
          iframe(src: rails_blob_path(ebook.pdf, only_path: true), width: "100%", height: "600px", frameborder: "0")
        else
          "No PDF available"
        end
      end
      row 'Images' do |ebook|
        if ebook.images.attached?
          ul do
            ebook.images.each do |image|
              li do
                image_tag(rails_blob_path(image, only_path: true), height: '100')
              end
            end
          end
        else
          'No images'
        end
      end
    end
    active_admin_comments
  end 
  
  form do |f|
    f.inputs "Ebook Details" do
      f.input :title
      f.input :author
      f.input :edition
      publisher = AccountBlock::Account.joins(:role).where(roles: {name: "Publisher"})
      f.input :publisher, as: :select, collection: publisher.distinct.pluck(:publication_house_name),include_blank: false
      f.input :publication_date,  as: :date_select,
                                  start_year: current_year,
                                  end_year: current_year - 100,
                                  order: [:day, :month, :year],
                                  include_blank: false
      f.input :formats_available
      f.input :language
      f.input :description
      f.input :price
      f.input :commission_percentage
      f.input :board, as: :select, collection: BxBlockCategories::School.distinct.pluck(:board), include_blank: false
      f.input :school_class_id, as: :select, collection: 1..12, include_blank: false
      f.input :subject, as: :select, collection: BxBlockCatalogue::Subject.distinct.pluck(:subject_name), include_blank: false
      f.input :pdf, as: :file, hint: f.object.pdf.attached? ? link_to('View PDF', url_for(f.object.pdf), target: '_blank') : content_tag(:span, 'No PDF available!'), direct_upload: true
      f.input :images, as: :file, input_html: { multiple: true, direct_upload: true }
      if f.object.images.attached?
        div class: 'image-preview-links' do
          f.object.images.each do |image|
            div class: 'image-preview-link' do
              link_to 'Preview Image', url_for(image), target: '_blank'
            end
          end
        end
      end
      # f.input :images, as: :file, input_html: { multiple: true, accept: 'image/*', limit: 3, 'data-max-file-count' => 3 }
    end
    f.actions
  end
  
  action_item :only => :index do
    link_to 'Upload Excel', :action => 'upload_excel'
  end
  action_item :only => :index do
    link_to 'Download Sample', :action => 'download_sample'
  end

  collection_action :upload_excel do
    render 'admin/ebooks/upload_excel'
  end

  collection_action :download_sample do
    send_file Rails.root.join('public/sample', 'sample1.xlsx'),
              filename: 'sample_ebook_template.xlsx',
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  collection_action :import_excel, method: :post do
    
    if params[:ebook] && params[:ebook][:excel_file].present?
      excel_file = params[:ebook][:excel_file]
      if excel_file.original_filename.match(/\.(xlsx|xls)\z/)
        file = params[:ebook][:excel_file].tempfile
        # excel = Roo::Excelx.new(file.path)
        begin
          excel = Roo::Excelx.new(file.path)
        rescue StandardError
          flash[:error] = 'Error opening the Excel file. Please ensure it is a valid Excel file.'
          return redirect_to :action => :index
        end
        success_count = 0
        error_count = 0

        if excel&.last_row.to_i < 4
          flash[:error] = 'Excel file is blank or does not contain data.'
          return redirect_to :action => :index
        end

        (4..excel.last_row).each do |row_number|
          title = excel.cell(row_number, 1)
          author = excel.cell(row_number, 2)
          edition = excel.cell(row_number, 3)
          publisher = excel.cell(row_number, 4)
          publication_date = excel.cell(row_number, 5)
          formats_available = excel.cell(row_number, 6)
          language = excel.cell(row_number, 7)
          description = excel.cell(row_number, 8)
          price = excel.cell(row_number, 9)
          commission_percentage = excel.cell(row_number, 10)
          board = excel.cell(row_number, 11)
          school_class_id = excel.cell(row_number, 12)
          subject = excel.cell(row_number, 13)
          pdf_path = excel.cell(row_number, 14)
          images_paths = (15..17).map { |col| excel.cell(row_number, col) }

          ebook = BxBlockBulkUploading::Ebook.new(title: title, author: author, edition: edition, publisher: publisher, publication_date: publication_date, formats_available: formats_available, language: language, description: description, price: price, commission_percentage: commission_percentage, board: board, school_class_id: school_class_id, subject: subject)
          if pdf_path.present?# && File.exist?(pdf_path)
            pdf_file = download_file_from_link(pdf_path)
            ebook.pdf.attach(io: pdf_file, filename: 'downloaded_pdf.pdf') if pdf_file
          end

          if images_paths.present?
            images_paths.each do |image_link|
              image_link.strip! if image_link.respond_to?(:strip!)
              image_file = download_file_from_link(image_link)
              ebook.images.attach(io: image_file, filename: 'downloaded_image.jpg') if image_file
            end
          end

          if ebook.valid?
            ebook.save
            success_count += 1
            flash[:notice] = "#{success_count} ebooks imported successfully."
          else
            ebook.delete
            error_count += 1
             flash[:alert] = "#{error_count} ebooks failed to import due to failed validation or missing required column."
          end
        end
      else
        flash[:error] = 'Please upload a valid Excel file (.xlsx or .xls).'
      end
    else
      flash[:alert] = "No file selected for import."
    end
    redirect_to :action => :index
  end

  controller do
    def download_file_from_link(link)
      begin
        if link.match(/drive\.google\.com/)
          file_id = link.match(/(?:drive\.google\.com\/.*[?&]id=|drive\.google\.com\/.*\/d\/|drive\.google\.com\/open\?id=)([^"&?\/\s]{28,})/)[1]
          file_content = open("https://drive.google.com/uc?id=#{file_id}").read
        else
          file_content = URI.open(link).read
        end
        Tempfile.new.tap do |tempfile|
          tempfile.binmode
          tempfile.write(file_content)
          tempfile.rewind
        end
      rescue StandardError => e
        Rails.logger.error("Error downloading file from #{link}: #{e.message}")
        nil
      end
    end
  end
end
