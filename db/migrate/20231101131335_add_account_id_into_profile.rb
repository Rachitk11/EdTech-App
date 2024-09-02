class AddAccountIdIntoProfile < ActiveRecord::Migration[6.0]
  def change
  	add_column :bx_block_profile_profiles, :account_id, :integer
  end
end
