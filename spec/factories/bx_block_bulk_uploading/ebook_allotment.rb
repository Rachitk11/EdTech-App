FactoryBot.define do
    factory :ebook_allotment, class: 'BxBlockBulkUploading::EbookAllotment' do
      alloted_date {"Date.today"}
    end
end
