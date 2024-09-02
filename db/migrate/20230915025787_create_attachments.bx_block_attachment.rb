# This migration comes from bx_block_attachment (originally 20201120113422)
class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.references :account, null: false, foreign_key: true
      t.string :colour
      t.string :layout
      t.string :page_size
      t.string :scale
      t.string :print_sides
      t.integer :print_pages_from
      t.integer :print_pages_to
      t.integer :total_pages
      t.boolean :is_expired, default: false
      t.integer :total_attachment_pages
      t.string :pdf_url
      t.boolean :is_printed, default: false
      t.timestamps
    end
  end
end
