# This migration comes from bx_block_catalogue (originally 20210827150607)
class ChangeReviewsToCatalogueReviews < ActiveRecord::Migration[6.0]
  def change
    rename_table :reviews, :catalogue_reviews
  end
end
