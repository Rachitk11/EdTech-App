# This migration comes from bx_block_coupon_cg (originally 20200924094637)
class CreateCouponCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_codes do |t|
      t.string :title
      t.string :description
      t.string :code
      t.string :discount_type, default: 'flat'
      t.decimal :discount
      t.datetime :valid_from
      t.datetime :valid_to
      t.decimal :min_cart_value
      t.decimal :max_cart_value

      t.timestamps
    end
  end
end
