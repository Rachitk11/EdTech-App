# This migration comes from bx_block_admin (originally 20210212155020)
class CreateActiveAdminComments < ActiveRecord::Migration[6.0]
  def self.up
    unless table_exists?(:active_admin_comments)
      create_table :active_admin_comments do |t|
        t.string :namespace
        t.text   :body
        t.references :resource, polymorphic: true
        t.references :author, polymorphic: true
        t.timestamps
      end
      add_index :active_admin_comments, [:namespace]
    end
  end

  def self.down
    drop_table :active_admin_comments
  end
end
