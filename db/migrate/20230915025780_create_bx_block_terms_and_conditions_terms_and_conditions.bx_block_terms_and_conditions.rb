# This migration comes from bx_block_terms_and_conditions (originally 20220204105929)
class CreateBxBlockTermsAndConditionsTermsAndConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_terms_and_conditions_terms_and_conditions do |t|
      t.integer :account_id
      t.timestamps
    end
  end
end
