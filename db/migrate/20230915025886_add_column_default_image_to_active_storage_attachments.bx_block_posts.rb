# This migration comes from bx_block_posts (originally 20201223090635)
class AddColumnDefaultImageToActiveStorageAttachments < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_attachments, :default_image, :boolean, default: false
  end
end
