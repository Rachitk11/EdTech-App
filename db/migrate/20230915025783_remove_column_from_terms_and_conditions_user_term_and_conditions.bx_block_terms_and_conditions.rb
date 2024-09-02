# This migration comes from bx_block_terms_and_conditions (originally 20220630084058)
class RemoveColumnFromTermsAndConditionsUserTermAndConditions < ActiveRecord::Migration[6.0]
  def change
    remove_column :bx_block_terms_and_conditions_user_term_and_conditions, :status, :integer
  end
end
