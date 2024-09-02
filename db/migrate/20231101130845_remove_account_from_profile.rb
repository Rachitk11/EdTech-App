class RemoveAccountFromProfile < ActiveRecord::Migration[6.0]
  def change
  	remove_reference :bx_block_profile_profiles, :account, foreign_key: true
  end
end
