module BxBlockShoppingCart
  class Cart < BxBlockShoppingCart::ApplicationRecord
    self.table_name = :carts

    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many :cart_products, class_name: 'BxBlockShoppingCart::CartProduct', dependent: :destroy
    
    accepts_nested_attributes_for :cart_products

    def total_product_cost
      total_cost = 0
      BxBlockShoppingCart::Cart.find(self.id).cart_products.each do |product|
        @discount = BxBlockOrderManagement::Medicine.find(product.medicine_id).discount
        if @discount.present?
          @total_amount = BxBlockOrderManagement::Medicine.find(product.medicine_id).total_amount
          @discount_amount =  @total_amount - (@total_amount * @discount/100)
          total = product.product_count * @discount_amount
          total_cost += total
        else
          total = product.product_count * BxBlockOrderManagement::Medicine.find(product.medicine_id).total_amount
         total_cost += total
        end
      end
       return { total_cost: total_cost }
    end

    def total_cart_cost
      if total_product_cost[:total_cost].to_f > 500
        total_cart = (total_product_cost[:total_cost].to_f)
        return {total_cart: total_cart}
      else total_product_cost[:total_cost].to_f < 500
        total_cart = (total_product_cost[:total_cost].to_f + shipping_charge[:shipping_charge].to_f) 
        return {total_cart: total_cart}
      end
    end
  end
end
end