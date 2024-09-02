# This migration comes from bx_block_content_management (originally 20210422112809)
class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.references :account, null: false, foreign_key: true
      t.bigint :content_provider_id, index: true
      t.timestamps
    end
  end
end
