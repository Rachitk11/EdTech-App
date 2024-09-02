module BxBlockBulkUploading
  class EbookAllotment < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :ebook_allotments
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :ebook, class_name: "BxBlockBulkUploading::Ebook"
    belongs_to :student, class_name: "AccountBlock::Account", foreign_key: "student_id"
  end
end
