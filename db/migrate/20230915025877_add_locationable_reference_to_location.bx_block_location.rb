# frozen_string_literal: true
# This migration comes from bx_block_location (originally 20220804131649)
# This migration comes from bx_block_profile_bio (originally 20210811120439)

class AddLocationableReferenceToLocation < ActiveRecord::Migration[6.0]
  def change
    change_table :locations do |t|
      t.text 'address'
     
      t.references :locationable, polymorphic: true, null: true, index: true
    end
  end
end
