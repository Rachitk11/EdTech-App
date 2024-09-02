# This migration comes from bx_block_catalogue (originally 20201009140306)
class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :catalogue, null: false, foreign_key: true
      t.string :comment
      t.integer :rating

      t.timestamps
    end
  end
end
