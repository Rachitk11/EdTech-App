# This migration comes from bx_block_terms_and_conditions (originally 20221206130357)
class AddColumnToTermsAndConditions < ActiveRecord::Migration[6.0]
  def change
    add_column :bx_block_terms_and_conditions_user_term_and_conditions, :is_accepted, :boolean
  end
end
