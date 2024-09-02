class AddPublisherHouseNameIntoBxBlockProfileProfiles < ActiveRecord::Migration[6.0]
  def change
  	add_column :bx_block_profile_profiles, :publication_house_name, :string
  end
end
