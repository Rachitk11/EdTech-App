# This migration comes from bx_block_catalogue (originally 20221111080229)
class AddCurrencyToBrands < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :currency, :string
  end
end
