# This migration comes from bx_block_catalogue (originally 20221124101714)
class AddCurrencyToBrandAsEnum < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :currency, :integer, default: 0
  end
end
