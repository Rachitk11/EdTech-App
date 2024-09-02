class AddColumnsToBundlesTable < ActiveRecord::Migration[6.0]
  def change
  	add_column :bx_block_bulk_uploading_bundles, :board, :string
  	add_column :bx_block_bulk_uploading_bundles, :school_class_id, :string
  	add_column :bx_block_bulk_uploading_bundles, :subject, :string
  end
end
