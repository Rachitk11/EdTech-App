# This migration comes from bx_block_posts (originally 20200918072208)
class CreatePost < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :name, null: false
      t.string :description
      t.float :price
      t.string :currency
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
