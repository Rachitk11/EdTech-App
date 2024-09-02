class AddEbookIdIntoOrderItems < ActiveRecord::Migration[6.0]
  def change
  	add_column :order_items, :ebook_id, :integer
  	add_column :order_items, :bundle_management_id, :integer
  	change_column_null :order_items, :catalogue_id, true
  end
end
