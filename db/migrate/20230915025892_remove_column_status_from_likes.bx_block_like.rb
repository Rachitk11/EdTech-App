# This migration comes from bx_block_like (originally 20210211134238)
class RemoveColumnStatusFromLikes < ActiveRecord::Migration[6.0]
  def change
    remove_column :likes, :status
  end
end
