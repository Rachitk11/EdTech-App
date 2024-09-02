
module BxBlockBulkUploading
  class RemoveBook < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :remove_books
    belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :ebook, class_name: 'BxBlockBulkUploading::Ebook'
  end 
end
