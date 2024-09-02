module BxBlockCatalogue
  class Brand < BxBlockCatalogue::ApplicationRecord
    self.table_name = :brands

    enum currency: %i(GBP INR USD EUR)
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :currency, inclusion: { in: currencies.keys }
  end
end
