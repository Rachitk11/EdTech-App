# frozen_string_literal: true
# This migration comes from bx_block_bulk_uploading (originally 20220809104924)

class AddFilesToAttachments < ActiveRecord::Migration[6.0]
  def change
    add_column :attachments, :files, :string
  end
end
