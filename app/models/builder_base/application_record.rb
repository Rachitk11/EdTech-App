module BuilderBase
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
    self.store_full_sti_class = false
  end
end
