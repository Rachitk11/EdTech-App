require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::EbooksController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before(:each) do
    @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
    @admin.role = "super_admin"
    @admin.password = "password"
    @admin.save
    sign_in @admin
  end

  describe 'GET #index' do
    it 'displays the list of ebooks' do
      create(:ebook, title: 'Test Ebook')
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET edit' do
    let!(:ebook) { create(:ebook, :with_images, title: 'Test Ebook 203') }

    it 'displays image preview links if images are attached' do

      get :edit, params: { id: ebook.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include('image-preview-links')
      ebook.images.each do |image|
        expect(response.body).to include(image.blob.filename.to_s)
      end
    end

    it 'does not display image preview links if images are not attached' do
      ebook.images.detach
      get :edit, params: { id: ebook.id }

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include('image-preview-links')
      expect(response.body).not_to include('image-preview-link')
    end
  end

  describe "GET #show" do
    let(:ebook) { create(:ebook) }

    it "returns a successful response" do
      get :show, params: { id: ebook.id }
      expect(response).to be_successful
      expect(response.body).to include("PDF Size:")
      # expect(response.body).to include("Pages:")
    end
  end

  describe "POST #create" do
    it "create new ebook" do
      post :new, params: {title: "Book1", author: "A1", size: "10 MB", pages: 556, edition: "2018-19", publisher: "Publisher", publication_date: "2018/05/09", formats_available: "pdf", language: "English", description: "Book Description", price: 569 }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #upload_excel' do
    it 'returns a successful response with status ok' do
      get :upload_excel
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET download_sample' do
    it 'sends the sample ebook template file' do
      get :download_sample
      expect(response).to be_successful
      expect(response.headers['Content-Type']).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      expect(response.headers['Content-Disposition']).to include('sample_ebook_template.xlsx')
    end
  end

  describe 'POST #import_excel' do
    context 'with a valid Excel file' do
      
      it 'imports ebooks and redirects to index' do
        valid_excel_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample11.xlsx'), 'text/xlsx')
        post :import_excel, params: { ebook: { excel_file: valid_excel_file } }
        expect(response).to redirect_to(action: :index)
        # expect(flash[:notice]).to eq('2 ebooks imported successfully.')
      end

      it 'shows an alert message and deletes the invalid ebook' do
        valid_excel_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample11.xlsx'), 'text/xlsx')
        allow(Roo::Excelx).to receive(:new).and_return(double('Roo::Excelx', last_row: 4, cell: 'Valid Data'))

        invalid_ebook = build(:ebook, title: nil)
        allow(BxBlockBulkUploading::Ebook).to receive(:new).and_return(invalid_ebook)
        post :import_excel, params: { ebook: { excel_file: valid_excel_file } }
        expect(flash[:alert]).to eq('1 ebooks failed to import due to failed validation or missing required column.')
        expect(BxBlockBulkUploading::Ebook.where(id: invalid_ebook.id)).to be_empty
      end
    end

    context 'with an invalid Excel file' do
      invalid_excel_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/index.jpeg'), 'photo/jpeg')

      it 'shows an error message and redirects to index' do
        post :import_excel, params: { ebook: { excel_file: invalid_excel_file } }
        # expect(response).to redirect_to(admin_ebooks_path)
        expect(response).to redirect_to(action: :index)
        expect(flash[:error]).to eq('Please upload a valid Excel file (.xlsx or .xls).')
      end
    end

    context 'with a blank Excel file' do
      it 'shows an error message' do
        blank_excel_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/blank_excel.xlsx'), 'excel_file/xlsx')
        allow(Roo::Excelx).to receive(:new).and_return(double('Roo::Excelx', last_row: nil))
        post :import_excel, params: { ebook: { excel_file: blank_excel_file } }

        expect(response).to redirect_to(action: :index)
        expect(flash[:error]).to eq('Excel file is blank or does not contain data.')
      end
    end

    context 'with an error opening the Excel file' do
      it 'shows an error message' do
        valid_excel_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/blank_excel.xlsx'), 'excel_file/xlsx')
        allow(Roo::Excelx).to receive(:new).and_raise(StandardError)

        post :import_excel, params: { ebook: { excel_file: valid_excel_file } }

        expect(response).to redirect_to(action: :index)
        expect(flash[:error]).to eq('Error opening the Excel file. Please ensure it is a valid Excel file.')
      end
    end

    context 'without selecting a file for import' do
      it 'displays an alert message' do
        post :import_excel, params: { ebook: { excel_file: nil } }
        expect(response).to redirect_to(admin_ebooks_path)
        expect(flash[:alert]).to eq('No file selected for import.')
      end
    end
  end
end
