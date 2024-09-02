module BxBlockShoppingCart
  class CartProduct < BxBlockShoppingCart::ApplicationRecord
    self.table_name = :cart_products

    belongs_to :ebook, class_name: 'BxBlockBulkUploading::Ebook'
    belongs_to :cart, class_name: 'BxBlockShoppingCart::Cart'
  end
end