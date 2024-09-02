module BxBlockAddress
  class AddressSerializer < BuilderBase::BaseSerializer
    attributes(:latitude, :longitude, :address, :address_type)
  end
end
