# This migration comes from bx_block_posts (originally 20210531153506)
class UpdateBxBlockPostPost < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :price
    remove_column :posts, :currency
    add_column :posts, :body, :text
    add_column :posts, :location, :string
  end
end
