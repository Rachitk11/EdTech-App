class ChangeColumnIntoOrderItems < ActiveRecord::Migration[6.0]
  def change
  	change_column_null :order_items, :catalogue_variant_id, true
  end
end
