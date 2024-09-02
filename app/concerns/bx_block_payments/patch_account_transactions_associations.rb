module BxBlockPayments
  module PatchAccountTransactionsAssociations
    extend ActiveSupport::Concern

    included do
      has_many :transactions, class_name: "BxBlockPayments::Transaction", dependent: :destroy
    end
  end
end
