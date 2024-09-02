# This migration comes from bx_block_content_management (originally 20210401115322)
class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.integer :sub_category_id
      t.integer :category_id
      t.integer :content_type_id
      t.integer :language_id
      t.integer :status
      t.datetime :publish_date
      t.boolean :archived, default: false
      t.boolean :feature_article
      t.boolean :feature_video
      t.string :searchable_text
      t.integer :review_status
      t.string :feedback
      t.integer :admin_user_id
      t.bigint :view_count, default: 0
      t.references :contentable, polymorphic: true, index: true
      t.references :author, foreign_key: true
      t.timestamps
    end
  end
end
