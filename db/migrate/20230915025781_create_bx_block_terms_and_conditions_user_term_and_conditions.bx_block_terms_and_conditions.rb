# This migration comes from bx_block_terms_and_conditions (originally 20220208110939)
class CreateBxBlockTermsAndConditionsUserTermAndConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_terms_and_conditions_user_term_and_conditions do |t|
      t.integer :account_id
      t.integer :terms_and_condition_id
      t.integer :status
      t.timestamps
    end
  end
end
