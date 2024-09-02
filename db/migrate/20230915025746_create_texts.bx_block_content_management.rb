# This migration comes from bx_block_content_management (originally 20210304074724)
class CreateTexts < ActiveRecord::Migration[6.0]
  def change
    create_table :content_texts do |t|
      t.string :headline
      t.string :content
      t.string :hyperlink
      t.string :affiliation
      t.timestamps
    end
  end
end
