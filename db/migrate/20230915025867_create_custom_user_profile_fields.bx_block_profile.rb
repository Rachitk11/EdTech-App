# This migration comes from bx_block_profile (originally 20230218193215)
class CreateCustomUserProfileFields < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_user_profile_fields do |t|
      t.string :name ,index: true
      t.string :field_type
      t.boolean :is_enable,  :null => false, :default => true
      t.boolean :is_required,  :null => false, :default => true

      t.timestamps
    end
  end
end
