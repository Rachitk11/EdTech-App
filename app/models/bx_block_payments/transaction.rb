module BxBlockPayments
  class Transaction < BxBlockPayments::ApplicationRecord
    self.table_name = :transactions

    enum status: { failed: 0, success: 1 }
    belongs_to :account, class_name: 'AccountBlock::Account'
  
  end
end
