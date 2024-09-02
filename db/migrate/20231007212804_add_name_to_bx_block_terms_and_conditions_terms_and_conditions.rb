class AddNameToBxBlockTermsAndConditionsTermsAndConditions < ActiveRecord::Migration[6.0]
  def change
    add_column :bx_block_terms_and_conditions_terms_and_conditions, :name, :string
  end
end
