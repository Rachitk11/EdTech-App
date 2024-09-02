# This migration comes from bx_block_elasticsearch (originally 20230328091731)
class CreateBxBlockElasticsearchArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_elasticsearch_articles do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
