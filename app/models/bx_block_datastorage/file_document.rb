module BxBlockDatastorage
	class FileDocument < ApplicationRecord
		self.table_name = :bx_block_datastorage_file_documents

		belongs_to :account, class_name: 'AccountBlock::Account'
		has_many_attached :attachments
		validates :title, :description, presence: true
		enum document_type: ["document", "certificate", "achievement"]

		def document_file_url
			file_array = []
			if self.attachments.attached?
				self.attachments.each do |file|
					file_array << { file: Rails.application.routes.url_helpers.rails_blob_path(file, disposition: "attachment", only_path: true) }
				end
			end
			file_array
		end
	end
end
