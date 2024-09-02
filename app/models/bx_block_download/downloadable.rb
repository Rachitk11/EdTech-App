module BxBlockDownload
  class Downloadable < BxBlockDownload::ApplicationRecord
    self.table_name = :bx_block_download_downloadables
    include Wisper::Publisher

    has_many_attached :files

    validates :files, :reference_id, :reference_type, presence: true
  end
end
