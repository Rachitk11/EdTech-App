# This migration comes from bx_block_posts (originally 20210805172242)
class AddAccountIdToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :account_id, :integer
  end
end
