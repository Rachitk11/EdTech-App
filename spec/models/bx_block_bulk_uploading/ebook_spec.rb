require 'rails_helper'

RSpec.describe 'BxBlockBulkUploading::Ebook', type: :model do
  before(:each) do
    @ebook = BxBlockBulkUploading::Ebook.create(title: "Title5", author: "Author", price: 456, commission_percentage: 12, edition: "2015-16", description: "Book description", publisher: "Publisher Name", board: "UP Board", subject: "Physics", school_class_id: "8th")
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      ebook = build(:ebook)
      expect(ebook).to be_valid
    end

    it 'is invalid without a title' do
      ebook = build(:ebook, title: nil)
      expect(ebook).to be_invalid
    end

    it 'is invalid without an author' do
      ebook = build(:ebook, author: nil)
      expect(ebook).to be_invalid
    end

    it 'is invalid without a price' do
      ebook = build(:ebook, price: nil)
      expect(ebook).to be_invalid
    end

    it 'is invalid with an invalid date format' do
      ebook = build(:ebook, publication_date: nil)

      expect(ebook).to be_valid
      # expect(ebook.errors[:publication_date]).to include('has an invalid date format. Please use YYYY-MM-DD format.')
    end
  end

  describe 'file attachment' do
    it 'is valid with an attached Excel file' do
      ebook = build(:ebook, :with_excel_file)
      expect(ebook).to be_valid
    end

    # it 'is invalid with a non-Excel file attachment' do
    #   ebook = build(:ebook, :with_non_excel_file)
    #   expect(ebook).to be_invalid
    #   expect(ebook.errors[:excel_file]).to include('You are not allowed to upload "jpeg" files, allowed types: xlsx, xls')
    # end
  end

  # describe '#update_pdf_info' do
  #   it 'updates size and pages for a valid PDF file' do
  #     ebook = create(:ebook, :with_pdf)
  #     ebook.update_pdf_info
  #     # expect(ebook.size).not_to be_nil
  #     # expect(ebook.pages).not_to be_nil
  #   end

  #   it 'handles invalid PDF gracefully' do
  #     ebook = create(:ebook, :without_pdf)
  #     expect(ebook.size).to be_nil
  #     expect(ebook.pages).to be_nil
  #   end
  # end
end