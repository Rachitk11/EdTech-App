module BxBlockAnnotations
  class Annotation < BxBlockAnnotations::ApplicationRecord
    self.table_name = :bx_block_annotations

    belongs_to :account, class_name: 'AccountBlock::Account'
    scope :ordered_by_id, -> { reorder(:id).reverse_order }
  end
end
