module BxBlockShoppingCart
  class OrderItemSerializer < BuilderBase::BaseSerializer
    attributes(:price, :quantity, :taxable, :taxable_value, :other_charges)

    attribute :catalogue do |object|
      BxBlockCatalogue::CatalogueSerializer.new(object.catalogue)
    end
  end
end
