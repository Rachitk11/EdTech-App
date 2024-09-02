class BxBlockDownload::DownloadablesSerializer
  include JSONAPI::Serializer
  attributes :id, :reference_id, :reference_type, :last_download_at
  attribute :files do |object|
    if object.files.count > 0
      files = []
      object.files.each do |file|
        files << { id: file.id, name: file.filename, downloaded_at: file.downloaded_at }
      end
      files
    end
  end
end
